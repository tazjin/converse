-- Create a simple view that returns the list of threads ordered by
-- the last post that occured in the thread.

CREATE VIEW thread_index AS
  SELECT t.id AS thread_id,
         t.title AS title,
         t.author_name AS author_name,
         t.posted AS posted,
         p.id AS post_id
    FROM threads t
    JOIN (SELECT DISTINCT ON (thread_id) id, thread_id
          FROM posts
          ORDER BY thread_id, id DESC) AS p
    ON t.id = p.thread_id
    ORDER BY p.id DESC;
