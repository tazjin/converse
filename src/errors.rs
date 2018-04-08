//! This module defines custom error types using the `failure`-crate.
//! Links to foreign error types (such as database connection errors)
//! are established in a similar way as was tradition in
//! `error_chain`, albeit manually.

use std::result;
use actix_web::{ResponseError, HttpResponse};
use actix_web::http::StatusCode;

// Modules with foreign errors:
use actix;
use diesel;
use r2d2;
use tera;

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

    // This variant is used as a catch-all for wrapping
    // actix-web-compatible response errors, such as the errors it
    // throws itself.
    #[fail(display = "Actix response error: {}", error)]
    ActixWeb { error: Box<ResponseError> },
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
        ConverseError::ActixWeb { error: Box::new(error) }
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
