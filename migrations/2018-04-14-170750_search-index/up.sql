-- Prepare a materialised view containing the tsvector data for all
-- threads and posts. This view is indexed using a GIN-index to enable
-- performant full-text searches.
--
-- For now the query language is hardcoded to be English.

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
