-- Pizza Restaurant Database
-- https://pythonai211225-rgb.github.io/sql/07_design/exercise.html

CREATE TABLE customers (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
phone INTEGER UNIQUE NOT NULL,
address TEXT NOT NULL
);

CREATE TABLE pizzas_typs (
id INTEGER PRIMARY KEY AUTOINCREMENT,
typ TEXT NOT NULL,
unit_price REAL NOT NULL
);

CREATE TABLE toppings_typs (
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT NOT NULL,
price REAL NOT NULL
);

CREATE TABLE drink_typs (
id INTEGER PRIMARY KEY AUTOINCREMENT,
drink_name TEXT NOT NULL,
price REAL NOT NULL
);

CREATE TABLE topping_per_pizza (
order_id INTEGER,
pizza_id INTEGER,
topping_id INTEGER,
toppings_price REAL NOT NULL DEFAULT (0),
PRIMARY KEY (order_id, pizza_id, topping_id),
FOREIGN KEY (topping_id) REFERENCES toppings_typs(id) ON DELETE RESTRICT,
FOREIGN KEY (order_id, pizza_id) REFERENCES pizza_order(order_id, pizza_id) ON DELETE CASCADE
);

CREATE TABLE pizza_order (
order_id INTEGER NOT NULL,
pizza_id INTEGER NOT NULL,
qty INTEGER NOT NULL,
price REAL NOT NULL DEFAULT (0),
PRIMARY KEY (order_id, pizza_id),
FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
FOREIGN KEY (pizza_id) REFERENCES pizzas_typs(id) ON DELETE RESTRICT
);

CREATE TABLE drink_order (
order_id INTEGER NOT NULL,
drink_id INTEGER NOT NULL,
unit_price REAL NOT NULL DEFAULT (0),
qty INTEGER NOT NULL,
PRIMARY KEY (order_id, drink_id),
FOREIGN KEY (drink_id) REFERENCES drink_typs(id) ON DELETE RESTRICT,
FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE orders (
id INTEGER PRIMARY KEY AUTOINCREMENT,
order_time TEXT NOT NULL DEFAULT (TIME('now')),
customer_id INTEGER NOT NULL,
total_price REAL NOT NULL DEFAULT (0),
FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT
);
_______________________________________________________________________________________________

INSERT INTO pizzas_typs (typ, unit_price)
VALUES ('pizza_margarita', 49.90),
('Four cheeses', 53.90), 
('Pepperoni', 52.90), 
('Capricciosa', 55.90), 
('Pizza Bianca', 52.90);

INSERT INTO toppings_typs (title, price)
VALUES ('olives', 2.0), ('Mushrooms', 3), ('pineapple', 5.0);

INSERT INTO drink_typs (drink_name, price)
VALUES ('cola', 10.00), ('sprite', 10.0), ('orange_juice', 12.9);

INSERT INTO customers (name, phone, address)
VALUES ('John Doe', '+1-555-0198', '123 Elm Street, Albany, NY'),
('Jane Smith', '+1-555-0143', '456 Oak Avenue, Riverdale, NY'),
('Michael Brown', '+1-555-0122', '789 Maple Drive, Buffalo, NY'),
('Emily Davis', '+1-555-0177', '321 Pine Lane, Rochester, NY'),
('David Wilson', '+1-555-0155', '654 Cedar Road, Syracuse, NY');

INSERT INTO orders (customer_id)
VALUES (1), (2), (3);

INSERT INTO pizza_order (order_id, pizza_id, qty)
VALUES (1, 2, 2), (2, 1, 1), (3, 3, 2);

INSERT INTO topping_per_pizza (order_id, pizza_id, topping_id, toppings_price)
VALUES (1, 2, 1, (SELECT price FROM toppings_typs WHERE id = 1)),
(1, 2, 2, (SELECT price FROM toppings_typs WHERE id = 2)),
(2, 1, NULL, 0),
(3, 3, 3, (SELECT price FROM toppings_typs WHERE id = 3));

UPDATE pizza_order
SET price = (SELECT unit_price FROM pizzas_typs WHERE pizzas_typs.id = pizza_order.pizza_id)
+ (SELECT SUM(toppings_price) FROM topping_per_pizza
WHERE (topping_per_pizza.pizza_id = pizza_order.pizza_id) 
AND (topping_per_pizza.order_id = pizza_order.order_id))
WHERE price = 0;

INSERT INTO drink_order 
VALUES (1, 3, (SELECT price FROM drink_typs WHERE drink_typs.id = 3), 2);

UPDATE orders 
SET total_price = (
(SELECT IFNULL(SUM(unit_price * qty), 0)
FROM drink_order
WHERE drink_order.order_id = orders.id
) + (
SELECT IFNULL(SUM(price * qty), 0) 
FROM pizza_order
WHERE pizza_order.order_id = orders.id)
)
WHERE total_price = 0;


