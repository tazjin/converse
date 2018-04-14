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

//! This module defines custom error types using the `failure`-crate.
//! Links to foreign error types (such as database connection errors)
//! are established in a similar way as was tradition in
//! `error_chain`, albeit manually.

use std::result;
use actix_web::{ResponseError, HttpResponse};
use actix_web::http::StatusCode;

// Modules with foreign errors:
use actix;
use actix_web;
use diesel;
use r2d2;
use reqwest;
use tera;
use tokio_timer;

pub type Result<T> = result::Result<T, ConverseError>;

#[derive(Debug, Fail)]
pub enum ConverseError {
    #[fail(display = "an internal Converse error occured: {}", reason)]
    InternalError { reason: String },

    #[fail(display = "a database error occured: {}", error)]
    Database { error: diesel::result::Error },

    #[fail(display = "a database connection pool error occured: {}", error)]
    ConnectionPool { error: r2d2::Error },

    #[fail(display = "a template rendering error occured: {}", reason)]
    Template { reason: String },

    #[fail(display = "error occured during request handling: {}", error)]
    ActixWeb { error: actix_web::Error },

    #[fail(display = "error occured running timer: {}", error)]
    Timer { error: tokio_timer::Error },

    // This variant is used as a catch-all for wrapping
    // actix-web-compatible response errors, such as the errors it
    // throws itself.
    #[fail(display = "Actix response error: {}", error)]
    Actix { error: Box<ResponseError> },
}

// Establish conversion links to foreign errors:

impl From<diesel::result::Error> for ConverseError {
    fn from(error: diesel::result::Error) -> ConverseError {
        ConverseError::Database { error }
    }
}

impl From<r2d2::Error> for ConverseError {
    fn from(error: r2d2::Error) -> ConverseError {
        ConverseError::ConnectionPool { error }
    }
}

impl From<tera::Error> for ConverseError {
    fn from(error: tera::Error) -> ConverseError {
        ConverseError::Template {
            reason: format!("{}", error),
        }
    }
}

impl From<actix::MailboxError> for ConverseError {
    fn from(error: actix::MailboxError) -> ConverseError {
        ConverseError::Actix { error: Box::new(error) }
    }
}

impl From<actix_web::Error> for ConverseError {
    fn from(error: actix_web::Error) -> ConverseError {
        ConverseError::ActixWeb { error }
    }
}

impl From<reqwest::Error> for ConverseError {
    fn from(error: reqwest::Error) -> ConverseError {
        ConverseError::InternalError {
            reason: format!("Failed to make HTTP request: {}", error),
        }
    }
}

impl From<tokio_timer::Error> for ConverseError {
    fn from(error: tokio_timer::Error) -> ConverseError {
        ConverseError::Timer { error }
    }
}

// Support conversion of error type into HTTP error responses:

impl ResponseError for ConverseError {
    fn error_response(&self) -> HttpResponse {
        // Everything is mapped to internal server errors for now.
        HttpResponse::build(StatusCode::INTERNAL_SERVER_ERROR)
            .body(format!("An error occured: {}", self))
    }
}
