#[macro_use]
extern crate diesel;

#[macro_use]
extern crate log;

extern crate chrono;
extern crate actix;
extern crate actix_web;
extern crate env_logger;
extern crate r2d2;
extern crate futures;

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
    db: Addr<Syn, DbExecutor>,
}

/// Really inefficient renderer example!
fn render_threads(threads: Vec<Thread>) -> String {
    let mut res = String::new();

    for thread in threads {
        res.push_str(&format!("Subject: {}\n", thread.title));
        res.push_str(&format!("Posted at: {}\n\n", thread.posted));
        res.push_str(&format!("{}\n", thread.body));
        res.push_str("-------------------------------");
    }

    res
}

fn forum_index(req: HttpRequest<AppState>) -> FutureResponse<HttpResponse> {
    req.state().db.send(ListThreads)
        .from_err()
        .and_then(|res| match res {
            Ok(threads) => Ok(HttpResponse::from(render_threads(threads))),
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
        App::with_state(AppState { db: db_addr.clone() })
            .middleware(middleware::Logger::default())
            .route("/", http::Method::GET, &forum_index)
    }).bind("127.0.0.1:4567").unwrap().start();

    let _ = sys.run();
}
