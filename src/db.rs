//! This module implements the database connection actor.

use actix::prelude::*;
use actix_web::Error;
use diesel::prelude::*;
use diesel::r2d2::{Pool, ConnectionManager};
use models::*;

/// The DB actor itself. Several of these will be run in parallel by
/// `SyncArbiter`.
pub struct DbExecutor(pub Pool<ConnectionManager<PgConnection>>);

impl Actor for DbExecutor {
    type Context = SyncContext<Self>;
}

/// Message used to request a list of threads.
/// TODO: This should support page numbers.
pub struct ListThreads;

impl Message for ListThreads {
    type Result = Result<Vec<Thread>, Error>;
}

impl Handler<ListThreads> for DbExecutor {
    type Result = <ListThreads as Message>::Result;

    fn handle(&mut self, _: ListThreads, _: &mut Self::Context) -> Self::Result {
        use schema::threads::dsl::*;

        let conn = self.0.get().unwrap();
        let results = threads.load::<Thread>(&conn).expect("Error loading threads");
        Ok(results)
    }
}

/// Message used to fetch a specific thread. Returns the thread and
/// its posts.
pub struct GetThread(pub i32);

impl Message for GetThread {
    type Result = Result<(Thread, Vec<Post>), Error>;
}

impl Handler<GetThread> for DbExecutor {
    type Result = <GetThread as Message>::Result;

    fn handle(&mut self, msg: GetThread, _: &mut Self::Context) -> Self::Result {
        use schema::threads::dsl::*;
        let conn = self.0.get().unwrap();
        let result: Thread = threads
            .find(msg.0).first(&conn)
            .expect("Error loading thread");

        Ok((result, vec![]))
    }
}
