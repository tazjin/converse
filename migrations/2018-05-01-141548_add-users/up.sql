-- This query creates a users table and migrates the existing user
-- information (from the posts table) into it.

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR NOT NULL UNIQUE,
  name VARCHAR NOT NULL,
  admin BOOLEAN NOT NULL DEFAULT false
);

-- Insert the 'anonymous' user explicitly:
INSERT INTO users (name, email)
  VALUES ('Anonymous', 'anonymous@nothing.org');

INSERT INTO users (id, email, name)
  SELECT nextval('users_id_seq'),
         author_email AS email,
         author_name AS name
  FROM posts
  WHERE author_email != 'anonymous@nothing.org'
  GROUP BY name, email;

-- Create the 'user_id' column in the relevant tables (initially
-- without a not-null constraint) and populate it with the data
-- selected above:
ALTER TABLE posts ADD COLUMN user_id INTEGER REFERENCES users (id);
UPDATE posts SET user_id = users.id
  FROM users
  WHERE users.email = posts.author_email;

ALTER TABLE threads ADD COLUMN user_id INTEGER REFERENCES users (id);
UPDATE threads SET user_id = users.id
  FROM users
  WHERE users.email = threads.author_email;

-- Add the constraints:
ALTER TABLE posts ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE threads ALTER COLUMN user_id SET NOT NULL;

-- Update the index view:
CREATE OR REPLACE VIEW thread_index AS
  SELECT t.id AS thread_id,
         t.title AS title,
         ta.name AS thread_author,
         t.posted AS created,
         t.sticky AS sticky,
         p.id AS post_id,
         pa.name AS post_author,
         p.posted AS posted
    FROM threads t
    JOIN (SELECT DISTINCT ON (thread_id)
           id, thread_id, user_id, posted
          FROM posts
          ORDER BY thread_id, id DESC) AS p
    ON t.id = p.thread_id
    JOIN users ta ON ta.id = t.user_id
    JOIN users pa ON pa.id = p.user_id
    ORDER BY t.sticky DESC, p.id DESC;

-- Update the search view:
DROP MATERIALIZED VIEW search_index;
CREATE MATERIALIZED VIEW search_index AS
  SELECT p.id AS post_id,
         pa.name AS author,
         t.id AS thread_id,
         t.title AS title,
         p.body AS body,
         setweight(to_tsvector('english', t.title), 'B') ||
         setweight(to_tsvector('english', p.body), 'A') ||
         setweight(to_tsvector('simple', ta.name), 'C') ||
         setweight(to_tsvector('simple', pa.name), 'C') AS document
    FROM posts p
    JOIN threads t ON t.id = p.thread_id
    JOIN users ta ON ta.id = t.user_id
    JOIN users pa ON pa.id = p.user_id;

CREATE INDEX idx_fts_search ON search_index USING gin(document);

-- And drop the old fields:
ALTER TABLE posts DROP COLUMN author_name;
ALTER TABLE posts DROP COLUMN author_email;
ALTER TABLE threads DROP COLUMN author_name;
ALTER TABLE threads DROP COLUMN author_email;
