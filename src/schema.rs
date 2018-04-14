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

// Note: Manually inserted as print-schema does not add views.
table! {
    thread_index (thread_id){
        thread_id -> Integer,
        title -> Text,
        author_name -> Text,
        posted -> Timestamptz,
        post_id -> Integer,
    }
}

joinable!(posts -> threads (thread_id));

allow_tables_to_appear_in_same_query!(
    posts,
    threads,
);
