use chrono::prelude::{DateTime, Utc};
use schema::{threads, posts};

#[derive(Identifiable, Queryable, Serialize)]
pub struct Thread {
    pub id: i32,
    pub title: String,
    pub body: String,
    pub posted: DateTime<Utc>,
    pub author_name: String,
    pub author_email: String,
}

#[derive(Identifiable, Queryable, Serialize, Associations)]
#[belongs_to(Thread)]
pub struct Post {
    pub id: i32,
    pub thread_id: i32,
    pub body: String,
    pub posted: DateTime<Utc>,
    pub author_name: String,
    pub author_email: String,
}

#[derive(Deserialize, Insertable)]
#[table_name="threads"]
pub struct NewThread {
    pub title: String,
    pub body: String,
}

#[derive(Deserialize, Insertable)]
#[table_name="posts"]
pub struct NewPost {
    pub thread_id: i32,
    pub body: String,
}
