-- 2NF: Partial Dependency

-- 1. Identify which columns have partial dependencies and what they depend on.
-- PRIMARY KEY (order_id, product_id).
-- customer_name depend on order_id onlly.
-- product_name depend on product_id onlly.
-- unit_price depend on product_id onlly.

-- 2. Design a 2NF-compliant schema: customers, products, orders, order_items.
-- Screenshot attached

-- 3. Write CREATE TABLE statements for all four tables.

CREATE TABLE customers (
id INTEGER PRIMARY KEY AUTOINCREMENT,
customer_name TEXT
);

CREATE TABLE products (
id INTEGER PRIMARY KEY,
product_name TEXT,
unit_price REAL
);

CREATE TABLE orders (
id INTEGER PRIMARY KEY,
customer_id INTEGER,
FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items (
order_id INTEGER,
product_id INTEGER,
qty INTEGER,
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 4. Insert the data from the original table into your 2NF schema.

INSERT INTO customers (customer_name)
VALUES ('Alice'), ('Bob');

INSERT INTO products (id, product_name, unit_price)
VALUES (42, 'Keyboard', 49.99), (77, 'Mouse', 29.99);

INSERT INTO orders (id, customer_id)
VALUES (1001, 1), (1002, 2);

INSERT INTO order_items (order_id, product_id, qty)
VALUES (1001, 42, 2), (1001, 77, 1), (1002, 42, 1);

-- 5. Write a query to reproduce the original table's data using JOINs.
SELECT oi.order_id, oi.product_id, oi.qty, c.customer_name, p.product_name, p.unit_price
FROM orders o JOIN customers c ON c.id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id ;

-- 6. Bonus: rename "Keyboard" to "Mechanical Keyboard" — in the bad table vs the 2NF table. How many rows changed in each?
UPDATE products
SET product_name = 'Mechanical Keyboard'
WHERE product_name = 'Keyboard';
-- in bad table need to change tow rows. in 2NF tables changed one row in product table onlly.
