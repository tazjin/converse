#[macro_use]
extern crate diesel;
extern crate chrono;

pub mod schema;
pub mod models;

use diesel::prelude::*;
use diesel::pg::PgConnection;
use std::env;

fn connect_db() -> PgConnection {
    let db_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");

    PgConnection::establish(&db_url)
        .expect(&format!("Error connecting to {}", db_url))
}

fn main() {
    use schema::threads::dsl::*;
    use models::*;

    let conn = connect_db();
    let result: Vec<Thread> = threads
        .load::<Thread>(&conn)
        .expect("Error loading threads");

    for thread in result {
        println!("Subject: {}\nPosted: {}\n", thread.title, thread.posted);
        println!("{}", thread.body);
    }
}
