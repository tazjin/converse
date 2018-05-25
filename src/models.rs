// Copyright (C) 2018  Vincent Ambo <mail@tazj.in>
//
// This file is part of Converse.
//
// Converse is free software: you can redistribute it and/or modify it
// under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program. If not, see
// <http://www.gnu.org/licenses/>.

use chrono::prelude::{DateTime, Utc};
use schema::{users, threads, posts, simple_posts};
use diesel::sql_types::{Text, Integer};

/// Represents a single user in the Converse database. Converse does
/// not handle logins itself, but rather looks them up based on the
/// email address received from an OIDC provider.
#[derive(Identifiable, Queryable, Serialize)]
pub struct User {
    pub id: i32,
    pub name: String,
    pub email: String,
    pub admin: bool,
}

#[derive(Identifiable, Queryable, Serialize, Associations)]
#[belongs_to(User)]
pub struct Thread {
    pub id: i32,
    pub title: String,
    pub posted: DateTime<Utc>,
    pub sticky: bool,
    pub user_id: i32,
    pub closed: bool,
}

#[derive(Identifiable, Queryable, Serialize, Associations)]
#[belongs_to(Thread)]
#[belongs_to(User)]
pub struct Post {
    pub id: i32,
    pub thread_id: i32,
    pub body: String,
    pub posted: DateTime<Utc>,
    pub user_id: i32,
}

/// This struct is used as the query result type for the simplified
/// post view, which already joins user information in the database.
#[derive(Identifiable, Queryable, Serialize, Associations)]
#[belongs_to(Thread)]
pub struct SimplePost {
    pub id: i32,
    pub thread_id: i32,
    pub body: String,
    pub posted: DateTime<Utc>,
    pub user_id: i32,
    pub closed: bool,
    pub author_name: String,
    pub author_email: String,
}

/// This struct is used as the query result type for the thread index
/// view, which lists the index of threads ordered by the last post in
/// each thread.
#[derive(Queryable, Serialize)]
pub struct ThreadIndex {
    pub thread_id: i32,
    pub title: String,
    pub thread_author: String,
    pub created: DateTime<Utc>,
    pub sticky: bool,
    pub closed: bool,
    pub post_id: i32,
    pub post_author: String,
    pub posted: DateTime<Utc>,
}

#[derive(Deserialize, Insertable)]
#[table_name="threads"]
pub struct NewThread {
    pub title: String,
    pub user_id: i32,
}

#[derive(Deserialize, Insertable)]
#[table_name="users"]
pub struct NewUser {
    pub email: String,
    pub name: String,
}

#[derive(Deserialize, Insertable)]
#[table_name="posts"]
pub struct NewPost {
    pub thread_id: i32,
    pub body: String,
    pub user_id: i32,
}

/// This struct models the response of a full-text search query. It
/// does not use a table/schema definition struct like the other
/// tables, as no table of this type actually exists.
#[derive(QueryableByName, Debug, Serialize)]
pub struct SearchResult {
    #[sql_type = "Integer"]
    pub post_id: i32,
    #[sql_type = "Integer"]
    pub thread_id: i32,
    #[sql_type = "Text"]
    pub author: String,
    #[sql_type = "Text"]
    pub title: String,

    /// Headline represents the result of Postgres' ts_headline()
    /// function, which highlights search terms in the search results.
    #[sql_type = "Text"]
    pub headline: String,
}
