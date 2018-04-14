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

use chrono::prelude::{DateTime, Utc};
use schema::{threads, posts};

#[derive(Identifiable, Queryable, Serialize)]
pub struct Thread {
    pub id: i32,
    pub title: String,
    pub posted: DateTime<Utc>,
    pub author_name: String,
    pub author_email: String,
}

/// This struct is used as the query type for the thread index view,
/// which lists the index of threads ordered by the last post in each
/// thread.
#[derive(Queryable, Serialize)]
pub struct ThreadIndex {
    pub thread_id: i32,
    pub title: String,
    pub author_name: String,
    pub posted: DateTime<Utc>,
    pub post_id: i32,
}

#[derive(Identifiable, Queryable, Serialize, Associations)]
#[belongs_to(Thread)]
pub struct Post {
    pub id: i32,
    pub thread_id: i32,
    pub body: String,
    pub posted: DateTime<Utc>,
    pub author_name: String,
    pub author_email: String,
}

#[derive(Deserialize, Insertable)]
#[table_name="threads"]
pub struct NewThread {
    pub title: String,
    pub author_name: String,
    pub author_email: String,
}

#[derive(Deserialize, Insertable)]
#[table_name="posts"]
pub struct NewPost {
    pub thread_id: i32,
    pub body: String,
    pub author_name: String,
    pub author_email: String,
}
