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
    pub threads: Vec<Thread>,
}

impl Message for IndexPage {
    type Result = Result<String>;
}

#[derive(Debug, Serialize)]
struct IndexThread {
    id: i32,
    title: String,
    posted: FormattedDate,
    author_name: String,
}

impl Handler<IndexPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: IndexPage, _: &mut Self::Context) -> Self::Result {
        let threads: Vec<IndexThread> = msg.threads
            .into_iter()
            .map(|thread| IndexThread {
                id: thread.id,
                title: escape_html(&thread.title),
                posted: thread.posted.into(),
                author_name: thread.author_name,
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
    let mut posts = vec![RenderablePost {
        // Always pin the ID of the first post.
        id: 0,
        body: markdown_to_html(&page.thread.body, comrak),
        posted: page.thread.posted.into(),
        author_name: page.thread.author_name,
        author_gravatar: md5_hex(page.thread.author_email.as_bytes()),
    }];

    for post in page.posts {
        posts.push(RenderablePost {
            id: post.id,
            body: markdown_to_html(&post.body, comrak),
            posted: post.posted.into(),
            author_name: post.author_name,
            author_gravatar: md5_hex(post.author_email.as_bytes()),
        });
    }

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
pub struct NewThreadPage;

impl Message for NewThreadPage {
    type Result = Result<String>;
}

impl Handler<NewThreadPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, _: NewThreadPage, _: &mut Self::Context) -> Self::Result {
        Ok(self.tera.render("new-thread.html", &Context::new())?)
    }
}
