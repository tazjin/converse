-- Add support for stickies in threads
ALTER TABLE threads ADD COLUMN sticky BOOLEAN NOT NULL DEFAULT FALSE;

-- CREATE a simple view that returns the list of threads ordered by
-- the last post that occured in the thread.
CREATE VIEW thread_index AS
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
