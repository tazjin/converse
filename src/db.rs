//! This module implements the database connection actor.

use actix::prelude::*;
use diesel::prelude::PgConnection;
use diesel::r2d2::{Pool, ConnectionManager};

/// The DB actor itself. Several of these will be run in parallel by
/// `SyncArbiter`.
pub struct DbExecutor(pub Pool<ConnectionManager<PgConnection>>);

impl Actor for DbExecutor {
    type Context = SyncContext<Self>;
}
