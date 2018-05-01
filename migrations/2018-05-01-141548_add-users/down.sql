-- First restore the old columns:
ALTER TABLE threads ADD COLUMN author_name VARCHAR;
ALTER TABLE threads ADD COLUMN author_email VARCHAR;
ALTER TABLE posts ADD COLUMN author_name VARCHAR;
ALTER TABLE posts ADD COLUMN author_email VARCHAR;

-- Then select the data back into them:
UPDATE threads SET author_name = users.name,
                   author_email = users.email
  FROM users
  WHERE threads.user_id = users.id;

UPDATE posts SET author_name = users.name,
                 author_email = users.email
  FROM users
  WHERE posts.user_id = users.id;

-- add the constraints back:
ALTER TABLE threads ALTER COLUMN author_name SET NOT NULL;
ALTER TABLE threads ALTER COLUMN author_email SET NOT NULL;
ALTER TABLE posts ALTER COLUMN author_name SET NOT NULL;
ALTER TABLE posts ALTER COLUMN author_email SET NOT NULL;

-- reset the index view:
CREATE OR REPLACE VIEW thread_index AS
  SELECT t.id AS thread_id,
         t.title AS title,
         t.author_name AS thread_author,
         t.posted AS created,
         t.sticky AS sticky,
         p.id AS post_id,
         p.author_name AS post_author,
         p.posted AS posted
    FROM threads t
    JOIN (SELECT DISTINCT ON (thread_id)
           id, thread_id, author_name, posted
          FROM posts
          ORDER BY thread_id, id DESC) AS p
    ON t.id = p.thread_id
    ORDER BY t.sticky DESC, p.id DESC;

-- reset the search view:
DROP MATERIALIZED VIEW search_index;
CREATE MATERIALIZED VIEW search_index AS
  SELECT p.id AS post_id,
         p.author_name AS author,
         t.id AS thread_id,
         t.title AS title,
         p.body AS body,
         setweight(to_tsvector('english', t.title), 'B') ||
         setweight(to_tsvector('english', p.body), 'A') ||
         setweight(to_tsvector('simple', t.author_name), 'C') ||
         setweight(to_tsvector('simple', p.author_name), 'C') AS document
    FROM posts p
    JOIN threads t
    ON t.id = p.thread_id;

CREATE INDEX idx_fts_search ON search_index USING gin(document);

-- and drop the users table and columns:
ALTER TABLE posts DROP COLUMN user_id;
ALTER TABLE threads DROP COLUMN user_id;
DROP TABLE users;
