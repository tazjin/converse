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

//! This module implements the database connection actor.

use actix::prelude::*;
use diesel::{self, sql_query};
use diesel::sql_types::Text;
use diesel::prelude::*;
use diesel::r2d2::{Pool, ConnectionManager};
use models::*;
use errors::{ConverseError, Result};

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
    type Result = Result<Vec<ThreadIndex>>;
}

impl Handler<ListThreads> for DbExecutor {
    type Result = <ListThreads as Message>::Result;

    fn handle(&mut self, _: ListThreads, _: &mut Self::Context) -> Self::Result {
        use schema::thread_index::dsl::*;

        let conn = self.0.get()?;
        let results = thread_index
            .load::<ThreadIndex>(&conn)?;
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

/// Message used to create a new thread
pub struct CreateThread {
    pub new_thread: NewThread,
    pub post: String,
}

impl Message for CreateThread {
    type Result = Result<Thread>;
}

impl Handler<CreateThread> for DbExecutor {
    type Result = <CreateThread as Message>::Result;

    fn handle(&mut self, msg: CreateThread, _: &mut Self::Context) -> Self::Result {
        use schema::threads;
        use schema::posts;

        let conn = self.0.get()?;

        conn.transaction::<Thread, ConverseError, _>(|| {
            // First insert the thread structure itself
            let thread: Thread = diesel::insert_into(threads::table)
                .values(&msg.new_thread)
                .get_result(&conn)?;

            // ... then create the first post in the thread.
            let new_post = NewPost {
                thread_id: thread.id,
                body: msg.post,
                author_name: msg.new_thread.author_name.clone(),
                author_email: msg.new_thread.author_email.clone(),
            };

            diesel::insert_into(posts::table)
                .values(&new_post)
                .execute(&conn)?;

            Ok(thread)
        })
    }
}

/// Message used to create a new reply
pub struct CreatePost(pub NewPost);

impl Message for CreatePost {
    type Result = Result<Post>;
}

impl Handler<CreatePost> for DbExecutor {
    type Result = <CreatePost as Message>::Result;

    fn handle(&mut self, msg: CreatePost, _: &mut Self::Context) -> Self::Result {
        use schema::posts;

        let conn = self.0.get()?;

        Ok(diesel::insert_into(posts::table)
           .values(&msg.0)
           .get_result(&conn)?)
    }
}

/// Message used to search for posts
#[derive(Deserialize)]
pub struct SearchPosts { pub query: String }

impl Message for SearchPosts {
    type Result = Result<Vec<SearchResult>>;
}

/// Raw PostgreSQL query used to perform full-text search on posts
/// with a supplied phrase. For now, the query language is hardcoded
/// to English and only "plain" queries (i.e. no searches for exact
/// matches or more advanced query syntax) are supported.
const SEARCH_QUERY: &'static str = r#"
WITH search_query (query) AS (VALUES (plainto_tsquery('english', $1)))
SELECT post_id,
       thread_id,
       author,
       title,
       ts_headline('english', body, query) AS headline
  FROM search_index, search_query
  WHERE document @@ query
  ORDER BY ts_rank(document, query) DESC
  LIMIT 50
"#;

impl Handler<SearchPosts> for DbExecutor {
    type Result = <SearchPosts as Message>::Result;

    fn handle(&mut self, msg: SearchPosts, _: &mut Self::Context) -> Self::Result {
        let conn = self.0.get()?;

        let search_results = sql_query(SEARCH_QUERY)
            .bind::<Text, _>(msg.query)
            .get_results::<SearchResult>(&conn)?;

        Ok(search_results)
    }
}

/// Message that triggers a refresh of the view used for full-text
/// searching.
pub struct RefreshSearchView;

impl Message for RefreshSearchView {
    type Result = Result<()>;
}

const REFRESH_QUERY: &'static str = "REFRESH MATERIALIZED VIEW search_index";

impl Handler<RefreshSearchView> for DbExecutor {
    type Result = Result<()>;

    fn handle(&mut self, _: RefreshSearchView, _: &mut Self::Context) -> Self::Result {
        let conn = self.0.get()?;
        debug!("Refreshing search_index view in DB");
        sql_query(REFRESH_QUERY).execute(&conn)?;
        Ok(())
    }
}
