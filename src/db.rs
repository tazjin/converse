//! This module implements the database connection actor.

use actix::prelude::*;
use diesel::prelude::*;
use diesel::r2d2::{Pool, ConnectionManager};
use models::*;
use errors::Result;

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
    type Result = Result<Vec<Thread>>;
}

impl Handler<ListThreads> for DbExecutor {
    type Result = <ListThreads as Message>::Result;

    fn handle(&mut self, _: ListThreads, _: &mut Self::Context) -> Self::Result {
        use schema::threads::dsl::*;

        let conn = self.0.get()?;
        let results = threads.load::<Thread>(&conn)?;
        Ok(results)
    }
}

/// Message used to fetch a specific thread. Returns the thread and
/// its posts.
pub struct GetThread(pub i32);

impl Message for GetThread {
    type Result = Result<(Thread, Vec<Post>)>;
}

impl Handler<GetThread> for DbExecutor {
    type Result = <GetThread as Message>::Result;

    fn handle(&mut self, msg: GetThread, _: &mut Self::Context) -> Self::Result {
        use schema::threads::dsl::*;

        let conn = self.0.get()?;
        let thread_result: Thread = threads
            .find(msg.0).first(&conn)?;

        let post_list = Post::belonging_to(&thread_result).load::<Post>(&conn)?;

        Ok((thread_result, post_list))
    }
}
