// Copyright (C) 2018  Vincent Ambo <mail@tazj.in>
//
// Converse is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see
// <http://www.gnu.org/licenses/>.

#[macro_use]
extern crate diesel;

#[macro_use]
extern crate log;

#[macro_use]
extern crate tera;

#[macro_use]
extern crate serde_derive;

#[macro_use]
extern crate failure;

extern crate actix;
extern crate actix_web;
extern crate chrono;
extern crate comrak;
extern crate env_logger;
extern crate futures;
extern crate hyper;
extern crate md5;
extern crate r2d2;
extern crate rand;
extern crate reqwest;
extern crate serde;
extern crate serde_json;
extern crate tokio;
extern crate tokio_timer;
extern crate url;
extern crate url_serde;

pub mod db;
pub mod errors;
pub mod handlers;
pub mod models;
pub mod oidc;
pub mod render;
pub mod schema;

use actix::prelude::*;
use actix_web::*;
use actix_web::middleware::{Logger, SessionStorage, CookieSessionBackend};
use actix_web::http::Method;
use db::*;
use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};
use std::env;
use rand::{OsRng, Rng};
use handlers::*;

fn config(name: &str) -> String {
    env::var(name).expect(&format!("{} must be set", name))
}

fn config_default(name: &str, default: &str) -> String {
    env::var(name).unwrap_or(default.into())
}

fn main() {
    env_logger::init();

    info!("Welcome to Converse! Hold on tight while we're getting ready.");
    let sys = actix::System::new("converse");

    info!("Initialising database connection pool ...");
    let db_url = config("DATABASE_URL");

    let manager = ConnectionManager::<PgConnection>::new(db_url);
    let pool = Pool::builder().build(manager).expect("Failed to initialise DB pool");

    let db_addr = SyncArbiter::start(2, move || DbExecutor(pool.clone()));

    schedule_search_refresh(db_addr.clone());

    info!("Initialising OIDC integration ...");
    let oidc_url = config("OIDC_DISCOVERY_URL");
    let oidc_config = oidc::load_oidc(&oidc_url)
        .expect("Failed to retrieve OIDC discovery document");
    let base_url = config("BASE_URL");

    let oidc = oidc::OidcExecutor {
        oidc_config,
        client_id: config("OIDC_CLIENT_ID"),
        client_secret: config("OIDC_CLIENT_SECRET"),
        redirect_uri: format!("{}/oidc/callback", config("BASE_URL")),
    };

    let oidc_addr: Addr<Syn, oidc::OidcExecutor> = oidc.start();

    info!("Compiling templates ...");
    let template_path = concat!(env!("CARGO_MANIFEST_DIR"), "/templates/**/*");
    let mut tera = compile_templates!(template_path);
    tera.autoescape_on(vec![]);
    let comrak = comrak::ComrakOptions{
        github_pre_lang: true,
        ext_strikethrough: true,
        ext_table: true,
        ext_autolink: true,
        ext_tasklist: true,
        ext_footnotes: true,
        ..Default::default()
    };
    let renderer = render::Renderer{ tera, comrak };
    let renderer_addr: Addr<Syn, render::Renderer> = renderer.start();

    info!("Initialising HTTP server ...");
    let bind_host = config_default("CONVERSE_BIND_HOST", "127.0.0.1:4567");
    let key = {
        let mut key_bytes = [0; 32];
        let mut rng = OsRng::new()
            .expect("Failed to retrieve RNG for key generation");
        rng.fill_bytes(&mut key_bytes);

        key_bytes
    };

    let require_login = config_default("REQUIRE_LOGIN", "true".into()) == "true";

    server::new(move || {
        let state = AppState {
            db: db_addr.clone(),
            oidc: oidc_addr.clone(),
            renderer: renderer_addr.clone(),
        };

        let sessions = SessionStorage::new(
            CookieSessionBackend::signed(&key)
                .secure(base_url.starts_with("https")));

        let app = App::with_state(state)
            .middleware(Logger::default())
            .middleware(sessions)
            .resource("/", |r| r.method(Method::GET).with(forum_index))
            .resource("/thread/new", |r| r.method(Method::GET).with(new_thread))
            .resource("/thread/submit", |r| r.method(Method::POST).with3(submit_thread))
            .resource("/thread/reply", |r| r.method(Method::POST).with3(reply_thread))
            .resource("/thread/{id}", |r| r.method(Method::GET).with2(forum_thread))
            .resource("/search", |r| r.method(Method::GET).with2(search_forum))
            .resource("/oidc/login", |r| r.method(Method::GET).with(login))
            .resource("/oidc/callback", |r| r.method(Method::POST).with3(callback));

        if require_login {
            app.middleware(RequireLogin)
        } else {
            app
        }})
        .bind(&bind_host).expect(&format!("Could not bind on '{}'", bind_host))
        .start();

    let _ = sys.run();
}

fn schedule_search_refresh(db: Addr<Syn, DbExecutor>) {
    use tokio::prelude::*;
    use tokio::timer::Interval;
    use std::time::{Duration, Instant};
    use std::thread;

    let task = Interval::new(Instant::now(), Duration::from_secs(60))
        .from_err()
        .for_each(move |_| db.send(db::RefreshSearchView).flatten())
        .map_err(|err| error!("Error while updating search view: {}", err));
        //.and_then(|_| debug!("Refreshed search view in DB"));

    thread::spawn(|| tokio::run(task));
}
