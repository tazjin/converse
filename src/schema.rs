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
        sticky -> Bool,
    }
}

// Note: Manually inserted as print-schema does not add views.
table! {
    thread_index (thread_id){
        thread_id -> Int4,
        title -> Text,
        thread_author -> Text,
        created -> Timestamptz,
        sticky -> Bool,
        post_id -> Int4,
        post_author -> Text,
        posted -> Timestamptz,
    }
}

joinable!(posts -> threads (thread_id));

allow_tables_to_appear_in_same_query!(
    posts,
    threads,
);
