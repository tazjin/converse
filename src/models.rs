use chrono::prelude::{DateTime, Utc};
use schema::{threads, posts};

#[derive(Identifiable, Queryable, Serialize)]
pub struct Thread {
    pub id: i32,
    pub title: String,
    pub body: String,
    pub posted: DateTime<Utc>,
}

#[derive(Identifiable, Queryable, Serialize, Associations)]
#[belongs_to(Thread)]
pub struct Post {
    pub id: i32,
    pub thread_id: i32,
    pub body: String,
    pub posted: DateTime<Utc>,
}

#[derive(Deserialize, Insertable)]
#[table_name="threads"]
pub struct NewThread {
    pub title: String,
    pub body: String,
}
