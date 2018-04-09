//! This module provides authentication via OIDC compliant
//! authentication sources.
//!
//! Currently Converse only supports a single OIDC provider. Note that
//! this has so far only been tested with Office365.

use actix::prelude::*;
use reqwest;
use url::Url;
use url_serde;
use errors::*;
use reqwest::header::Authorization;
use hyper::header::Bearer;

/// This structure represents the contents of an OIDC discovery
/// document.
#[derive(Deserialize, Debug, Clone)]
pub struct OidcConfig {
    #[serde(with = "url_serde")]
    authorization_endpoint: Url,
    token_endpoint: String,
    userinfo_endpoint: String,

    scopes_supported: Vec<String>,
    issuer: String,
}

#[derive(Clone, Debug)]
pub struct OidcExecutor {
    pub client_id: String,
    pub client_secret: String,
    pub redirect_uri: String,
    pub oidc_config: OidcConfig,
}

/// This struct represents the form response returned by an OIDC
/// provider with the `code`.
#[derive(Debug, Deserialize)]
pub struct CodeResponse {
    pub code: String,
}

/// This struct represents the data extracted from the ID token and
/// stored in the user's session.
#[derive(Debug, Serialize, Deserialize)]
pub struct Author {
    pub name: String,
    pub email: String,
}

impl Actor for OidcExecutor {
    type Context = Context<Self>;
}

/// Message used to request the login URL:
pub struct GetLoginUrl; // TODO: Add a nonce parameter stored in session.

impl Message for GetLoginUrl {
    type Result = String;
}

impl Handler<GetLoginUrl> for OidcExecutor {
    type Result = String;

    fn handle(&mut self, _: GetLoginUrl, _: &mut Self::Context) -> Self::Result {
        let mut url: Url = self.oidc_config.authorization_endpoint.clone();
        {
            let mut params = url.query_pairs_mut();
            params.append_pair("client_id", &self.client_id);
            params.append_pair("response_type", "code");
            params.append_pair("scope", "openid");
            params.append_pair("redirect_uri", &self.redirect_uri);
            params.append_pair("response_mode", "form_post");
        }
        return url.into_string();
    }
}

/// Message used to request the token from the returned code and
/// retrieve userinfo from the appropriate endpoint.
pub struct RetrieveToken(pub CodeResponse);

impl Message for RetrieveToken {
    type Result = Result<Author>;
}

#[derive(Debug, Deserialize)]
struct TokenResponse {
    access_token: String,
}

// TODO: This is currently hardcoded to Office365 fields.
#[derive(Debug, Deserialize)]
struct Userinfo {
    name: String,
    unique_name: String, // email in office365
}

impl Handler<RetrieveToken> for OidcExecutor {
    type Result = Result<Author>;

    fn handle(&mut self, msg: RetrieveToken, _: &mut Self::Context) -> Self::Result {
        debug!("Received OAuth2 code, requesting access_token");
        let client = reqwest::Client::new();
        let params: [(&str, &str); 5] = [
            ("client_id", &self.client_id),
            ("client_secret", &self.client_secret),
            ("grant_type", "authorization_code"),
            ("code", &msg.0.code),
            ("redirect_uri", &self.redirect_uri),
        ];

        let response: TokenResponse = client.post(&self.oidc_config.token_endpoint)
            .form(&params)
            .send()?
            .json()?;

        let user: Userinfo = client.get(&self.oidc_config.userinfo_endpoint)
            .header(Authorization(Bearer { token: response.access_token }))
            .send()?
            .json()?;

        Ok(Author {
            name: user.name,
            email: user.unique_name,
        })
    }
}

/// Convenience function to attempt loading an OIDC discovery document
/// from a specified URL:
pub fn load_oidc(url: &str) -> Result<OidcConfig> {
    let config: OidcConfig = reqwest::get(url)?.json()?;
    Ok(config)
}
