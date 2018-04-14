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

//! This module contains the implementation of converse's actix-web
//! HTTP handlers.
//!
//! Most handlers have an associated rendering function using one of
//! the tera templates stored in the `/templates` directory in the
//! project root.

use actix::prelude::*;
use actix_web;
use actix_web::*;
use actix_web::middleware::{Started, Middleware, RequestSession};
use db::*;
use errors::ConverseError;
use futures::Future;
use models::*;
use oidc::*;
use render::*;

type ConverseResponse = Box<Future<Item=HttpResponse, Error=ConverseError>>;

const HTML: &'static str = "text/html";

/// Represents the state carried by the web server actors.
pub struct AppState {
    /// Address of the database actor
    pub db: Addr<Syn, DbExecutor>,

    /// Address of the OIDC actor
    pub oidc: Addr<Syn, OidcExecutor>,

    /// Address of the rendering actor
    pub renderer: Addr<Syn, Renderer>,
}

pub fn forum_index(state: State<AppState>) -> ConverseResponse {
    state.db.send(ListThreads)
        .flatten()
        .and_then(move |res| state.renderer.send(IndexPage {
            threads: res
        }).from_err())
        .flatten()
        .map(|res| HttpResponse::Ok().content_type(HTML).body(res))
        .responder()
}

/// This handler retrieves and displays a single forum thread.
pub fn forum_thread(state: State<AppState>, thread_id: Path<i32>) -> ConverseResponse {
    let id = thread_id.into_inner();
    state.db.send(GetThread(id))
        .flatten()
        .and_then(move |res| state.renderer.send(ThreadPage {
            thread: res.0,
            posts: res.1,
        }).from_err())
        .flatten()
        .map(|res| HttpResponse::Ok().content_type(HTML).body(res))
        .responder()
}

/// This handler presents the user with the "New Thread" form.
pub fn new_thread(state: State<AppState>) -> ConverseResponse {
    state.renderer.send(NewThreadPage::default()).flatten()
        .map(|res| HttpResponse::Ok().content_type(HTML).body(res))
        .responder()
}

/// This function provides an anonymous "default" author if logins are
/// not required.
fn anonymous() -> Author {
    Author {
        name: "Anonymous".into(),
        email: "anonymous@nothing.org".into(),
    }
}

#[derive(Deserialize)]
pub struct NewThreadForm {
    pub title: String,
    pub body: String,
}

const NEW_THREAD_LENGTH_ERR: &'static str = "Title and body can not be empty!";

/// This handler receives a "New thread"-form and redirects the user
/// to the new thread after creation.
pub fn submit_thread(state: State<AppState>,
                     input: Form<NewThreadForm>,
                     mut req: HttpRequest<AppState>) -> ConverseResponse {
    // Perform simple validation and abort here if it fails:
    if input.0.title.is_empty() || input.0.body.is_empty() {
        return state.renderer
            .send(NewThreadPage {
                alerts: vec![NEW_THREAD_LENGTH_ERR],
                title: Some(input.0.title),
                body: Some(input.0.body),
            })
            .flatten()
            .map(|res| HttpResponse::Ok().content_type(HTML).body(res))
            .responder();
    }

    let author: Author = req.session().get(AUTHOR)
        .unwrap_or_else(|_| Some(anonymous()))
        .unwrap_or_else(anonymous);

    let new_thread = NewThread {
        title: input.0.title,
        author_name: author.name,
        author_email: author.email,
    };

    let msg = CreateThread {
        new_thread,
        body: input.0.body,
    };

    state.db.send(msg)
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

#[derive(Deserialize)]
pub struct NewPostForm {
    pub thread_id: i32,
    pub body: String,
}

/// This handler receives a "Reply"-form and redirects the user to the
/// new post after creation.
pub fn reply_thread(state: State<AppState>,
                    input: Form<NewPostForm>,
                    mut req: HttpRequest<AppState>) -> ConverseResponse {
    let author: Author = req.session().get(AUTHOR)
        .unwrap_or_else(|_| Some(anonymous()))
        .unwrap_or_else(anonymous);

    let new_post = NewPost {
        thread_id: input.thread_id,
        body: input.0.body,
        author_name: author.name,
        author_email: author.email,
    };

    state.db.send(CreatePost(new_post))
        .flatten()
        .from_err()
        .and_then(move |post| {
            info!("Posted reply {} to thread {}", post.id, post.thread_id);
            Ok(HttpResponse::SeeOther()
               .header("Location", format!("/thread/{}#post-{}", post.thread_id, post.id))
               .finish())
        })
        .responder()
}

/// This handler executes a full-text search on the forum database and
/// displays the results to the user.
pub fn search_forum(state: State<AppState>,
                    query: Form<SearchPosts>) -> ConverseResponse {
    let query_string = query.0.query.clone();
    state.db.send(query.0)
        .flatten()
        .and_then(move |results| state.renderer.send(SearchResultPage {
            results,
            query: query_string,
        }).from_err())
        .flatten()
        .map(|res| HttpResponse::Ok().content_type(HTML).body(res))
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

const AUTHOR: &'static str = "author";

pub fn callback(state: State<AppState>,
                data: Form<CodeResponse>,
                mut req: HttpRequest<AppState>) -> ConverseResponse {
    state.oidc.send(RetrieveToken(data.0))
        .from_err()
        .and_then(move |result| {
            let author = result?;
            info!("Setting cookie for {} after callback", author.name);
            req.session().set(AUTHOR, author)?;
            Ok(HttpResponse::SeeOther()
               .header("Location", "/")
               .finish())})
        .responder()
}


/// Middleware used to enforce logins unceremoniously.
pub struct RequireLogin;

impl <S> Middleware<S> for RequireLogin {
    fn start(&self, req: &mut HttpRequest<S>) -> actix_web::Result<Started> {
        let has_author = req.session().get::<Author>(AUTHOR)?.is_some();
        let is_oidc_req = req.path().starts_with("/oidc");

        if !is_oidc_req && !has_author {
            Ok(Started::Response(
                HttpResponse::SeeOther()
                    .header("Location", "/oidc/login")
                    .finish()
            ))
        } else {
            Ok(Started::Done)
        }
    }
}
