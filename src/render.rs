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

//! This module defines a rendering actor used for processing Converse
//! data into whatever format is needed by the templates and rendering
//! them.

use actix::prelude::*;
use errors::*;
use md5;
use models::*;
use tera::{escape_html, Context, Tera};
use chrono::prelude::{DateTime, Utc};
use comrak::{ComrakOptions, markdown_to_html};

pub struct Renderer {
    pub tera: Tera,
    pub comrak: ComrakOptions,
}

impl Actor for Renderer {
    type Context = actix::Context<Self>;
}

/// Represents a data formatted for human consumption
#[derive(Debug, Serialize)]
struct FormattedDate(String);

impl From<DateTime<Utc>> for FormattedDate {
    fn from(date: DateTime<Utc>) -> Self {
        FormattedDate(format!("{}", date.format("%a %d %B %Y, %R")))
    }
}

/// Message used to render the index page.
pub struct IndexPage {
    pub threads: Vec<ThreadIndex>,
}

impl Message for IndexPage {
    type Result = Result<String>;
}

#[derive(Debug, Serialize)]
struct IndexThread {
    id: i32,
    title: String,
    sticky: bool,
    posted: FormattedDate,
    author_name: String,
}

impl Handler<IndexPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: IndexPage, _: &mut Self::Context) -> Self::Result {
        let threads: Vec<IndexThread> = msg.threads
            .into_iter()
            .map(|thread| IndexThread {
                id: thread.thread_id,
                title: escape_html(&thread.title),
                sticky: thread.sticky,
                posted: thread.posted.into(),
                author_name: thread.thread_author,
            })
            .collect();

        let mut ctx = Context::new();
        ctx.add("threads", &threads);
        Ok(self.tera.render("index.html", &ctx)?)
    }
}

/// Message used to render a thread.
pub struct ThreadPage {
    pub thread: Thread,
    pub posts: Vec<Post>,
}

impl Message for ThreadPage {
    type Result = Result<String>;
}

// "Renderable" structures with data transformations applied.
#[derive(Debug, Serialize)]
struct RenderablePost {
    id: i32,
    body: String,
    posted: FormattedDate,
    author_name: String,
    author_gravatar: String,
}

/// This structure represents the transformed thread data with
/// Markdown rendering and other changes applied.
#[derive(Debug, Serialize)]
struct RenderableThreadPage {
    id: i32,
    title: String,
    posts: Vec<RenderablePost>,
}

/// Helper function for computing Gravatar links.
fn md5_hex(input: &[u8]) -> String {
    format!("{:x}", md5::compute(input))
}

fn prepare_thread(comrak: &ComrakOptions, page: ThreadPage) -> RenderableThreadPage {
    let posts = page.posts.into_iter().map(|post| {
        let escaped_body = escape_html(&post.body);
        RenderablePost {
            id: post.id,
            body: markdown_to_html(&escaped_body, comrak),
            posted: post.posted.into(),
            author_name: post.author_name,
            author_gravatar: md5_hex(post.author_email.as_bytes()),
        }
    }).collect();

    RenderableThreadPage {
        posts,
        id: page.thread.id,
        title: escape_html(&page.thread.title),
    }
}

impl Handler<ThreadPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: ThreadPage, _: &mut Self::Context) -> Self::Result {
        let renderable = prepare_thread(&self.comrak, msg);
        let mut ctx = Context::new();
        ctx.add("title", &renderable.title);
        ctx.add("posts", &renderable.posts);
        ctx.add("id", &renderable.id);
        Ok(self.tera.render("thread.html", &ctx)?)
    }
}

/// Message used to render new thread page.
///
/// It can optionally contain a vector of warnings to display to the
/// user in alert boxes, such as input validation errors.
#[derive(Default)]
pub struct NewThreadPage {
    pub alerts: Vec<&'static str>,
    pub title: Option<String>,
    pub body: Option<String>,
}

impl Message for NewThreadPage {
    type Result = Result<String>;
}

impl Handler<NewThreadPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: NewThreadPage, _: &mut Self::Context) -> Self::Result {
        let mut ctx = Context::new();
        ctx.add("alerts", &msg.alerts);
        ctx.add("title", &msg.title.map(|s| escape_html(&s)));
        ctx.add("body", &msg.body.map(|s| escape_html(&s)));
        Ok(self.tera.render("new-thread.html", &ctx)?)
    }
}

/// Message used to render search results
pub struct SearchResultPage {
    pub query: String,
    pub results: Vec<SearchResult>,
}

impl Message for SearchResultPage {
    type Result = Result<String>;
}

impl Handler<SearchResultPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: SearchResultPage, _: &mut Self::Context) -> Self::Result {
        let mut ctx = Context::new();
        ctx.add("query", &msg.query);
        ctx.add("results", &msg.results);
        Ok(self.tera.render("search.html", &ctx)?)
    }
}
