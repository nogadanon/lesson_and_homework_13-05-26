-- 1NF : Atomic values; No repeating groups; Unique rows; Consistent column types

-- 3. Write CREATE TABLE statements for all tables with proper PKs and FKs.
CREATE TABLE contacts (
id INTEGER PRIMARY KEY AUTOINCREMENT,
full_name TEXT
);

CREATE TABLE email (
id_contacts INTEGER,
email TEXT,
PRIMARY KEY (id_contacts, email)
FOREIGN KEY (id_contacts) REFERENCES contacts(id)
);

CREATE TABLE tags (
id INTEGER PRIMARY KEY AUTOINCREMENT,
tag_name TEXT UNIQUE
);

CREATE TABLE tags_contacts (
id_contacts INTEGER,
id_tag INTEGER,
PRIMARY KEY (id_contacts, id_tag)
FOREIGN KEY (id_contacts) REFERENCES contacts(id)
FOREIGN KEY (id_tag) REFERENCES tags(id)
);

-- 4. Insert the data from the original table into your new schema.
INSERT INTO contacts (full_name)
VALUES ('Ana Silva'), ('João Souza');

INSERT INTO email (id_contacts, email)
VALUES (1, 'ana@a.com'), (1, 'ana@b.com'), (2, 'joao@c.com');

INSERT INTO tags (tag_name)
VALUES ('VIP'), ('Newsletter');

INSERT INTO tags_contacts (id_contacts, id_tag)
VALUES (1, 1), (1, 2), (2, 2);

-- 5. Write a query to find all contacts that have the tag 'Newsletter'.
SELECT t.tag_name, c.full_name
FROM contacts c JOIN tags_contacts tc ON tc.id_contacts = c.id
JOIN tags t ON t.id = tc.id_tag
WHERE t.tag_name = 'Newsletter';

-- 6. Write a query to find all emails for contact id 1.
SELECT c.id, c.full_name, e.email
FROM contacts c JOIN email e ON c.id = e.id_contacts
WHERE c.id = 1;

