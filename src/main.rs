#[macro_use]
extern crate diesel;

#[macro_use]
extern crate log;

#[macro_use]
extern crate tera;

#[macro_use]
extern crate serde_derive;

extern crate chrono;
extern crate actix;
extern crate actix_web;
extern crate env_logger;
extern crate r2d2;
extern crate futures;
extern crate serde;

pub mod schema;
pub mod models;
pub mod db;

use actix::prelude::*;
use actix_web::*;

use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};
use std::env;
use db::*;
use futures::Future;
use models::Thread;

/// Represents the state carried by the web server actors.
struct AppState {
    /// Address of the database actor
    db: Addr<Syn, DbExecutor>,

    /// Compiled templates
    tera: tera::Tera,
}

/// Really inefficient renderer example!
fn render_threads(tpl: &tera::Tera, threads: Vec<Thread>) -> String {
    let mut ctx = tera::Context::new();
    ctx.add("threads", &threads);
    tpl.render("index.html", &ctx).expect("Oh no")
}

fn forum_index(req: HttpRequest<AppState>) -> FutureResponse<HttpResponse> {
    req.state().db.send(ListThreads)
        .from_err()
        .and_then(move |res| match res {
            Ok(threads) => Ok(HttpResponse::Ok()
                              .content_type("text/html")
                              .body(render_threads(&req.state().tera, threads))),
            Err(err) => {
                error!("Error loading threads: {}", err);
                Ok(HttpResponse::InternalServerError().into())
            }
        })
        .responder()
}

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
    server::new(move || {
        let template_path = concat!(env!("CARGO_MANIFEST_DIR"), "/templates/**/*");
        let tera = compile_templates!(template_path);

        App::with_state(AppState { db: db_addr.clone(), tera })
            .middleware(middleware::Logger::default())
            .route("/", http::Method::GET, &forum_index)
    }).bind("127.0.0.1:4567").unwrap().start();

    let _ = sys.run();
}
