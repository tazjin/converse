-- Instead of storing the thread OP in the thread table, this will
-- make it a post as well.
-- At the time at which this migration was created no important data
-- existed in any converse instances, so data is not moved.

ALTER TABLE threads DROP COLUMN body;
