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
extern crate env_logger;
extern crate futures;
extern crate r2d2;
extern crate reqwest;
extern crate serde;
extern crate url;
extern crate url_serde;
extern crate serde_json;
extern crate hyper;

pub mod oidc;
pub mod db;
pub mod errors;
pub mod handlers;
pub mod models;
pub mod schema;

use actix::prelude::*;
use actix_web::*;
use actix_web::middleware::{Logger, SessionStorage, CookieSessionBackend};
use actix_web::http::Method;
use db::*;
use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};
use std::env;
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

    info!("Initialising OIDC integration ...");
    let oidc_url = config("OIDC_DISCOVERY_URL");
    let oidc_config = oidc::load_oidc(&oidc_url)
        .expect("Failed to retrieve OIDC discovery document");

    let oidc = oidc::OidcExecutor {
        oidc_config,
        client_id: config("OIDC_CLIENT_ID"),
        client_secret: config("OIDC_CLIENT_SECRET"),
        redirect_uri: format!("{}/oidc/callback", config("BASE_URL")),
    };

    let oidc_addr: Addr<Syn, oidc::OidcExecutor> = oidc.start();

    info!("Initialising HTTP server ...");
    let bind_host = config_default("CONVERSE_BIND_HOST", "127.0.0.1:4567");
    let key: &[u8] = &[0; 32]; // TODO: generate!

    server::new(move || {
        let template_path = concat!(env!("CARGO_MANIFEST_DIR"), "/templates/**/*");
        let tera = compile_templates!(template_path);
        let state = AppState {
            db: db_addr.clone(),
            oidc: oidc_addr.clone(),
            tera,
        };

        App::with_state(state)
            .middleware(Logger::default())
            // TODO: Configure session backend with more secure settings.
            .middleware(SessionStorage::new(CookieSessionBackend::new(key)))
            .resource("/", |r| r.method(Method::GET).with(forum_index))
            .resource("/thread/submit", |r| r.method(Method::POST).with2(submit_thread))
            .resource("/thread/reply", |r| r.method(Method::POST).with2(reply_thread))
            .resource("/thread/{id}", |r| r.method(Method::GET).with2(forum_thread))
            .resource("/oidc/login", |r| r.method(Method::GET).with(login))
            .resource("/oidc/callback", |r| r.method(Method::POST).with3(callback))})
        .bind(&bind_host).expect(&format!("Could not bind on '{}'", bind_host))
        .start();

    let _ = sys.run();
}
