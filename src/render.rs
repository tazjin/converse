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

//! This module defines a rendering actor used for processing Converse
//! data into whatever format is needed by the templates and rendering
//! them.

use actix::prelude::*;
use askama::Template;
use errors::*;
use std::fmt;
use md5;
use models::*;
use tera::Tera;
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
#[derive(Debug)]
struct FormattedDate(DateTime<Utc>);

impl fmt::Display for FormattedDate {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0.format("%a %d %B %Y, %R"))
    }
}

/// Message used to render the index page.
pub struct IndexPage {
    pub threads: Vec<ThreadIndex>,
}
message!(IndexPage, Result<String>);

#[derive(Debug)]
struct IndexThread {
    id: i32,
    title: String,
    sticky: bool,
    posted: FormattedDate,
    author_name: String,
    post_author: String,
}

#[derive(Template)]
#[template(path = "index.html")]
struct IndexPageTemplate {
    threads: Vec<IndexThread>,
}

impl Handler<IndexPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: IndexPage, _: &mut Self::Context) -> Self::Result {
        let threads: Vec<IndexThread> = msg.threads
            .into_iter()
            .map(|thread| IndexThread {
                id: thread.thread_id,
                title: thread.title, // escape_html(&thread.title),
                sticky: thread.sticky,
                posted: FormattedDate(thread.posted),
                author_name: thread.thread_author,
                post_author: thread.post_author,
            })
            .collect();

        let tpl = IndexPageTemplate {
            threads
        };

        tpl.render().map_err(|e| e.into())
    }
}

/// Message used to render a thread.
pub struct ThreadPage {
    pub current_user: i32,
    pub thread: Thread,
    pub posts: Vec<SimplePost>,
}
message!(ThreadPage, Result<String>);

// "Renderable" structures with data transformations applied.
#[derive(Debug)]
struct RenderablePost {
    id: i32,
    body: String,
    posted: FormattedDate,
    author_name: String,
    author_gravatar: String,
    editable: bool,
}

/// This structure represents the transformed thread data with
/// Markdown rendering and other changes applied.
#[derive(Template)]
#[template(path = "thread.html")]
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
    let user = page.current_user;

    let posts = page.posts.into_iter().map(|post| {
        let editable = user != 1 && post.user_id == user;

        RenderablePost {
            id: post.id,
            body: markdown_to_html(&post.body, comrak),
            posted: FormattedDate(post.posted),
            author_name: post.author_name.clone(),
            author_gravatar: md5_hex(post.author_email.as_bytes()),
            editable,
        }
    }).collect();

    RenderableThreadPage {
        posts,
        id: page.thread.id,
        title: page.thread.title,
    }
}

impl Handler<ThreadPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: ThreadPage, _: &mut Self::Context) -> Self::Result {
        let renderable = prepare_thread(&self.comrak, msg);
        renderable.render().map_err(|e| e.into())
    }
}

/// The different types of editing modes supported by the editing
/// template:
#[derive(Debug, PartialEq)]
pub enum EditingMode {
    NewThread,
    PostReply,
    EditPost,
}

impl Default for EditingMode {
    fn default() -> EditingMode { EditingMode::NewThread }
}

/// This is the template used for rendering the new thread, edit post
/// and reply to thread forms.
#[derive(Template, Default)]
#[template(path = "post.html")]
pub struct FormTemplate {
    /// Which editing mode is to be used by the template?
    pub mode: EditingMode,

    /// Potential alerts to display to the user (e.g. input validation
    /// results)
    pub alerts: Vec<&'static str>,

    /// Either the title to be used in the subject field or the title
    /// of the thread the user is responding to.
    pub title: Option<String>,

    /// Body of the post being edited, if present.
    pub post: Option<String>,

    /// ID of the thread being replied to or the post being edited.
    pub id: Option<i32>,
}

/// Message used to render new thread page.
///
/// It can optionally contain a vector of warnings to display to the
/// user in alert boxes, such as input validation errors.
#[derive(Default)]
pub struct NewThreadPage {
    pub alerts: Vec<&'static str>,
    pub title: Option<String>,
    pub post: Option<String>,
}
message!(NewThreadPage, Result<String>);

impl Handler<NewThreadPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: NewThreadPage, _: &mut Self::Context) -> Self::Result {
        let ctx = FormTemplate {
            alerts: msg.alerts,
            title: msg.title,
            post: msg.post,
            ..Default::default()
        };
        ctx.render().map_err(|e| e.into())
    }
}

/// Message used to render post editing page.
pub struct EditPostPage {
    pub id: i32,
    pub post: String,
}
message!(EditPostPage, Result<String>);

impl Handler<EditPostPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: EditPostPage, _: &mut Self::Context) -> Self::Result {
        let ctx = FormTemplate {
            mode: EditingMode::EditPost,
            id: Some(msg.id),
            post: Some(msg.post),
            ..Default::default()
        };

        ctx.render().map_err(|e| e.into())
    }
}

/// Message used to render search results
#[derive(Serialize)]
pub struct SearchResultPage {
    pub query: String,
    pub results: Vec<SearchResult>,
}
message!(SearchResultPage, Result<String>);

impl Handler<SearchResultPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: SearchResultPage, _: &mut Self::Context) -> Self::Result {
        Ok(self.tera.render("search.html", &msg)?)
    }
}
