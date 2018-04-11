//! This module defines a rendering actor used for processing Converse
//! data into whatever format is needed by the templates and rendering
//! them.

use actix::prelude::*;
use actix_web::HttpResponse;
use tera::{Context, Tera};
use models::*;
use errors::*;

pub struct Renderer(pub Tera);

impl Actor for Renderer {
    type Context = actix::Context<Self>;
}

/// Message used to render the index page.
pub struct IndexPage {
    pub threads: Vec<Thread>,
}

impl Message for IndexPage {
    type Result = Result<String>;
}

impl Handler<IndexPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: IndexPage, _: &mut Self::Context) -> Self::Result {
        let mut ctx = Context::new();
        ctx.add("threads", &msg.threads);
        Ok(self.0.render("index.html", &ctx)?)
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

impl Handler<ThreadPage> for Renderer {
    type Result = Result<String>;

    fn handle(&mut self, msg: ThreadPage, _: &mut Self::Context) -> Self::Result {
        let mut ctx = Context::new();
        ctx.add("thread", &msg.thread);
        ctx.add("posts", &msg.posts);
        Ok(self.0.render("thread.html", &ctx)?)
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
        Ok(self.0.render("new-thread.html", &Context::new())?)
    }
}
