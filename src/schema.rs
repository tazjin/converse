table! {
    posts (id) {
        id -> Int4,
        thread_id -> Int4,
        body -> Text,
        posted -> Timestamptz,
    }
}

table! {
    threads (id) {
        id -> Int4,
        title -> Varchar,
        body -> Text,
        posted -> Timestamptz,
    }
}

joinable!(posts -> threads (thread_id));

allow_tables_to_appear_in_same_query!(
    posts,
    threads,
);
