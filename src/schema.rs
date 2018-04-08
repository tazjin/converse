table! {
    posts (id) {
        id -> Int4,
        thread -> Int4,
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

joinable!(posts -> threads (thread));

allow_tables_to_appear_in_same_query!(
    posts,
    threads,
);
