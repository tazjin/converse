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
extern crate tera;
extern crate tokio;
extern crate tokio_timer;
extern crate url;
extern crate url_serde;

/// Simple macro used to reduce boilerplate when defining actor
/// message types.
macro_rules! message {
    ( $t:ty, $r:ty ) => {
        impl Message for $t {
            type Result = $r;
        }
    }
}

pub mod db;
pub mod errors;
pub mod handlers;
pub mod models;
pub mod oidc;
pub mod render;
pub mod schema;

use actix::prelude::*;
use actix_web::*;
use actix_web::http::Method;
use actix_web::middleware::{Logger, SessionStorage, CookieSessionBackend};
use db::*;
use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};
use handlers::*;
use oidc::OidcExecutor;
use rand::{OsRng, Rng};
use render::Renderer;
use std::env;
use tera::Tera;

fn config(name: &str) -> String {
    env::var(name).expect(&format!("{} must be set", name))
}

fn config_default(name: &str, default: &str) -> String {
    env::var(name).unwrap_or(default.into())
}

fn start_db_executor() -> Addr<Syn, DbExecutor> {
    info!("Initialising database connection pool ...");
    let db_url = config("DATABASE_URL");

    let manager = ConnectionManager::<PgConnection>::new(db_url);
    let pool = Pool::builder().build(manager).expect("Failed to initialise DB pool");

    SyncArbiter::start(2, move || DbExecutor(pool.clone()))
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

    thread::spawn(|| tokio::run(task));
}

fn start_oidc_executor(base_url: &str) -> Addr<Syn, OidcExecutor> {
    info!("Initialising OIDC integration ...");
    let oidc_url = config("OIDC_DISCOVERY_URL");
    let oidc_config = oidc::load_oidc(&oidc_url)
        .expect("Failed to retrieve OIDC discovery document");

    let oidc = oidc::OidcExecutor {
        oidc_config,
        client_id: config("OIDC_CLIENT_ID"),
        client_secret: config("OIDC_CLIENT_SECRET"),
        redirect_uri: format!("{}/oidc/callback", base_url),
    };

    oidc.start()
}

fn start_renderer() -> Addr<Syn, Renderer> {
    info!("Compiling templates ...");
    let mut tera: Tera = Default::default();

    // Include template strings into the binary instead of being
    // location-dependent.
    // Drawback is that template changes require recompilation ...
    tera.add_raw_templates(vec![
        ("index.html", include_str!("../templates/index.html")),
        ("post.html", include_str!("../templates/post.html")),
        ("search.html", include_str!("../templates/search.html")),
        ("thread.html", include_str!("../templates/thread.html")),
    ]).expect("Could not compile templates");

    let comrak = comrak::ComrakOptions{
        github_pre_lang: true,
        ext_strikethrough: true,
        ext_table: true,
        ext_autolink: true,
        ext_tasklist: true,
        ext_footnotes: true,
        ..Default::default()
    };

    Renderer{ tera, comrak }.start()
}

fn gen_session_key() -> [u8; 64] {
    let mut key_bytes = [0; 64];
    let mut rng = OsRng::new()
        .expect("Failed to retrieve RNG for key generation");
    rng.fill_bytes(&mut key_bytes);

    key_bytes
}

fn start_http_server(base_url: String,
                     db_addr: Addr<Syn, DbExecutor>,
                     oidc_addr: Addr<Syn, OidcExecutor>,
                     renderer_addr: Addr<Syn, Renderer>) {
    info!("Initialising HTTP server ...");
    let bind_host = config_default("CONVERSE_BIND_HOST", "127.0.0.1:4567");
    let key = gen_session_key();
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
            .resource("/thread/{id}", |r| r.method(Method::GET).with3(forum_thread))
            .resource("/post/{id}/edit", |r| r.method(Method::GET).with3(edit_form))
            .resource("/post/edit", |r| r.method(Method::POST).with3(edit_post))
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
}

fn main() {
    env_logger::init();

    info!("Welcome to Converse! Hold on tight while we're getting ready.");
    let sys = actix::System::new("converse");

    let base_url = config("BASE_URL");

    let db_addr = start_db_executor();
    let oidc_addr = start_oidc_executor(&base_url);
    let renderer_addr = start_renderer();

    schedule_search_refresh(db_addr.clone());

    start_http_server(base_url, db_addr, oidc_addr, renderer_addr);

    sys.run();
}
