-- 3NF: Transitive Dependency

-- 1. Check: is this table in 1NF? Explain why.
-- yes.
-- Atomic values - Each cell contains one single value.
-- No repeating groups
-- Unique rows - Every row have uniquely identifiable — PRIMARY KEY.
-- Consistent column types - All values ​​in the column are of the same type.

-- 2. Check: is this table in 2NF? Explain why (single-column PK).
-- yes. A partial dependency occurs when a non-key column depends on only part of a composite primary key. 
-- 2NF only matters when the primary key is composite (made of two or more columns). A table with a single-column PK is automatically in 2NF (if it's already in 1NF).

-- 3. Identify all transitive dependencies in the table.
-- author_name column depend author_id column.
-- publisher_name column depend publisher_id column.
-- publisher_city column depend publisher_id column.

-- 4. Design a 3NF schema with tables: books, authors, publishers.
-- Screenshot attached

-- 5. Write CREATE TABLE statements for all three tables with proper PKs and FKs.
CREATE TABLE authors (
id TEXT PRIMARY KEY,
name TEXT UNIQUE NOT NULL
);

CREATE TABLE publishers (
id TEXT PRIMARY KEY, 
name TEXT UNIQUE NOT NULL,
city TEXT
);

CREATE TABLE books (
isbn TEXT PRIMARY KEY,
title TEXT UNIQUE NOT NULL,
author_id TEXT,
publisher_id TEXT,
FOREIGN KEY (author_id) REFERENCES authors(id),
FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

-- 6. Insert the original data into the normalized tables.
INSERT INTO authors
VALUES ('A1', 'Jane Doe'), ('A2', 'John Smith');

INSERT INTO publishers
VALUES ('P1', 'TechPress', 'New York'), ('P2', 'DataBooks',	'Paris');

INSERT INTO books
VALUES ('978-1', 'SQL Mastery', 'A1', 'P1'),
('978-2', 'Python Pro', 'A2', 'P1'),
('978-3', 'Data Viz', 'A1', 'P2');

-- 7. Write a query to reproduce all original columns using JOINs.
SELECT b.isbn, b.title, b.author_id, a.name AS author_name, b.publisher_id, p.name AS publisher_name, p.city AS publisher_city
FROM books b LEFT JOIN authors a ON b.author_id = a.id
LEFT JOIN publishers p ON b.publisher_id = p.id;

-- 8. Bonus: Change Jane Doe's name to "Jane Doe-Smith" — how many rows change in the 3NF vs original schema?
UPDATE authors
SET name = 'Jane Doe-Smith'
WHERE name = 'Jane Doe';
-- in original table need to change tow rows. in 3NF tables changed one row in authors table onlly.




