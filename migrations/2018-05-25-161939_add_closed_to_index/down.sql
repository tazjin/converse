-- Update the index view:
DROP VIEW thread_index;
CREATE VIEW thread_index AS
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

-- Update the post view:
DROP VIEW simple_posts;
CREATE VIEW simple_posts AS
  SELECT p.id AS id,
         thread_id, body, posted, user_id,
         users.name AS author_name,
         users.email AS author_email
  FROM posts p
  JOIN users ON users.id = p.user_id;
