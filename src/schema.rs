table! {
    posts (id) {
        id -> Int4,
        thread_id -> Int4,
        body -> Text,
        posted -> Timestamptz,
        author_name -> Varchar,
        author_email -> Varchar,
    }
}

table! {
    threads (id) {
        id -> Int4,
        title -> Varchar,
        posted -> Timestamptz,
        author_name -> Varchar,
        author_email -> Varchar,
    }
}

joinable!(posts -> threads (thread_id));

allow_tables_to_appear_in_same_query!(
    posts,
    threads,
);
