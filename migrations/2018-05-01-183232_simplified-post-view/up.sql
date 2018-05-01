-- Creates a view for listing posts akin to the post table before
-- splitting out users. This exists to avoid having to do joining
-- logic and such inside of the application.

CREATE VIEW simple_posts AS
  SELECT p.id AS id,
         thread_id, body, posted, user_id,
         users.name AS author_name,
         users.email AS author_email
  FROM posts p
  JOIN users ON users.id = p.user_id;
