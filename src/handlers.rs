//! This module contains the implementation of converse's actix-web
//! HTTP handlers.
//!
//! Most handlers have an associated rendering function using one of
//! the tera templates stored in the `/templates` directory in the
//! project root.

use tera;
use actix_web::*;
use models::*;
use db::*;
use actix::prelude::{Addr, Syn};
use futures::Future;
use errors::{Result, ConverseError};

type ConverseResponse = Box<Future<Item=HttpResponse, Error=ConverseError>>;

/// Represents the state carried by the web server actors.
pub struct AppState {
    /// Address of the database actor
    pub db: Addr<Syn, DbExecutor>,

    /// Compiled templates
    pub tera: tera::Tera,
}

/// This function renders an overview of threads into the default
/// thread list template.
fn render_threads(tpl: &tera::Tera, threads: Vec<Thread>) -> Result<HttpResponse> {
    let mut ctx = tera::Context::new();
    ctx.add("threads", &threads);
    let body = tpl.render("index.html", &ctx)?;
    Ok(HttpResponse::Ok().content_type("text/html").body(body))
}

pub fn forum_index(state: State<AppState>) -> ConverseResponse {
    state.db.send(ListThreads)
        .from_err()
        .and_then(move |res| match res {
            Ok(threads) => Ok(render_threads(&state.tera, threads)?),
            Err(err) => {
                error!("Error loading threads: {}", err);
                Ok(HttpResponse::InternalServerError().into())
            }
        })
        .responder()
}

/// This function renders a single forum thread into the default
/// thread view.
fn render_thread(tpl: &tera::Tera, thread: Thread, posts: Vec<Post>)
                 -> Result<HttpResponse> {
    let mut ctx = tera::Context::new();
    ctx.add("thread", &thread);
    ctx.add("posts", &posts);

    let body = tpl.render("thread.html", &ctx)?;
    Ok(HttpResponse::Ok()
        .content_type("text/html")
        .body(body))
}

/// This handler retrieves and displays a single forum thread.
pub fn forum_thread(state: State<AppState>, thread_id: Path<i32>) -> ConverseResponse {
    let id = thread_id.into_inner();
    state.db.send(GetThread(id))
        .from_err()
        .and_then(move |res| match res {
            Ok((thread, posts)) => Ok(render_thread(&state.tera, thread, posts)?),
            Err(err) => {
                error!("Error loading thread {}: {}", id, err);
                Ok(HttpResponse::InternalServerError().into())
            }
        })
        .responder()
}
