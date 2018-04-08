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

extern crate chrono;
extern crate actix;
extern crate actix_web;
extern crate env_logger;
extern crate r2d2;
extern crate futures;
extern crate serde;

pub mod db;
pub mod errors;
pub mod handlers;
pub mod models;
pub mod schema;

use actix::prelude::*;
use actix_web::*;
use actix_web::http::Method;
use db::*;
use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};
use std::env;
use handlers::*;

fn main() {
    env_logger::init();

    info!("Welcome to Converse! Hold on tight while we're getting ready.");
    let sys = actix::System::new("converse");

    info!("Initialising database connection pool ...");
    let db_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");

    let manager = ConnectionManager::<PgConnection>::new(db_url);
    let pool = Pool::builder().build(manager).expect("Failed to initialise DB pool");

    let db_addr = SyncArbiter::start(2, move || DbExecutor(pool.clone()));

    info!("Initialising HTTP server ...");
    let bind_host = env::var("CONVERSE_BIND_HOST").unwrap_or("127.0.0.1:4567".into());

    server::new(move || {
        let template_path = concat!(env!("CARGO_MANIFEST_DIR"), "/templates/**/*");
        let tera = compile_templates!(template_path);

        App::with_state(AppState { db: db_addr.clone(), tera })
            .middleware(middleware::Logger::default())
            .resource("/", |r| r.method(Method::GET).with(forum_index))
            .resource("/thread/submit", |r| r.method(Method::POST).with2(submit_thread))
            .resource("/thread/reply", |r| r.method(Method::POST).with2(reply_thread))
            .resource("/thread/{id}", |r| r.method(Method::GET).with2(forum_thread))})
        .bind(&bind_host).expect(&format!("Could not bind on '{}'", bind_host))
        .start();

    let _ = sys.run();
}
