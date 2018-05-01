// Copyright (C) 2018  Vincent Ambo <mail@tazj.in>
//
// This file is part of Converse.
//
// Converse is free software: you can redistribute it and/or modify it
// under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program. If not, see
// <http://www.gnu.org/licenses/>.

table! {
    posts (id) {
        id -> Int4,
        thread_id -> Int4,
        body -> Text,
        posted -> Timestamptz,
        author -> Int4,
    }
}

table! {
    threads (id) {
        id -> Int4,
        title -> Varchar,
        posted -> Timestamptz,
        sticky -> Bool,
        author -> Int4,
    }
}

table! {
    users (id) {
        id -> Int4,
        email -> Varchar,
        name -> Varchar,
        admin -> Bool,
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
joinable!(posts -> users (author));
joinable!(threads -> users (author));

allow_tables_to_appear_in_same_query!(
    posts,
    threads,
    users,
);
