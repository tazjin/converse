-- This migration adds an 'author' column to the thread & post table.
-- Authors don't currently exist as independent objects in the
-- database as most user management is simply delegated to the OIDC
-- provider.

ALTER TABLE threads ADD COLUMN author_name VARCHAR NOT NULL DEFAULT 'anonymous';
ALTER TABLE threads ADD COLUMN author_email VARCHAR NOT NULL DEFAULT 'unknown@example.org';

ALTER TABLE posts ADD COLUMN author_name VARCHAR NOT NULL DEFAULT 'anonymous';
ALTER TABLE posts ADD COLUMN author_email VARCHAR NOT NULL DEFAULT 'unknown@example.org';
