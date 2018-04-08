//! This module contains the implementation of converse's actix-web
//! HTTP handlers.
//!
//! Most handlers have an associated rendering function using one of
//! the tera templates stored in the `/templates` directory in the
//! project root.

use actix::prelude::{Addr, Syn};
use actix_web::*;
use actix_web::middleware::RequestSession;
use db::*;
use errors::{Result, ConverseError};
use futures::Future;
use models::*;
use oidc::*;
use tera;

type ConverseResponse = Box<Future<Item=HttpResponse, Error=ConverseError>>;

/// Represents the state carried by the web server actors.
pub struct AppState {
    /// Address of the database actor
    pub db: Addr<Syn, DbExecutor>,

    /// Address of the OIDC actor
    pub oidc: Addr<Syn, OidcExecutor>,

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

/// This handler receives a "New thread"-form and redirects the user
/// to the new thread after creation.
pub fn submit_thread(state: State<AppState>, input: Form<NewThread>) -> ConverseResponse {
    state.db.send(CreateThread(input.0))
        .from_err()
        .and_then(move |res| {
            let thread = res?;
            info!("Created new thread \"{}\" with ID {}", thread.title, thread.id);
            Ok(HttpResponse::SeeOther()
               .header("Location", format!("/thread/{}", thread.id))
               .finish())
        })
        .responder()
}

/// This handler receives a "Reply"-form and redirects the user to the
/// new post after creation.
pub fn reply_thread(state: State<AppState>, input: Form<NewPost>) -> ConverseResponse {
    state.db.send(CreatePost(input.0))
        .from_err()
        .and_then(move |res| {
            let post = res?;
            info!("Posted reply {} to thread {}", post.id, post.thread_id);
            Ok(HttpResponse::SeeOther()
               .header("Location", format!("/thread/{}#post{}", post.thread_id, post.id))
               .finish())
        })
        .responder()
}

/// This handler initiates an OIDC login.
pub fn login(state: State<AppState>) -> ConverseResponse {
    state.oidc.send(GetLoginUrl)
        .from_err()
        .and_then(|url| Ok(HttpResponse::TemporaryRedirect()
                           .header("Location", url)
                           .finish()))
        .responder()
}

pub fn callback(state: State<AppState>,
                data: Form<CodeResponse>,
                mut req: HttpRequest<AppState>) -> ConverseResponse {
    state.oidc.send(RetrieveToken(data.0))
        .from_err()
        .and_then(move |result| {
            let author = result?;
            info!("Setting cookie for {} after callback", author.name);
            req.session().set("author_name", author.name)?;
            req.session().set("author_email", author.email)?;
            Ok(HttpResponse::SeeOther()
               .header("Location", "/")
               .finish())})
        .responder()
}
