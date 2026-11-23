-- Create database and select it
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Create customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

-- Create orders table linked to customers
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Insert sample customers
INSERT INTO customers (name, email, address) VALUES
('Arun Kumar', 'arun@example.com', '12 Anna Nagar, Chennai'),
('Priya Sharma', 'priya@example.com', '45 T Nagar, Chennai'),
('Karthik Raj', 'karthik@example.com', '7 Adyar, Chennai'),
('Divya Lakshmi', 'divya@example.com', '89 Velachery, Chennai'),
('Suresh Babu', 'suresh@example.com', '23 Tambaram, Chennai');

-- Insert sample products
INSERT INTO products (name, price, description) VALUES
('Product A', 120.00, 'Wireless headphones'),
('Product B', 75.50, 'Bluetooth speaker'),
('Product C', 30.00, 'USB charging cable'),
('Product D', 199.99, 'Smart watch'),
('Product E', 15.00, 'Phone case');

-- Insert sample orders relative to current date
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 195.50),
(2, DATE_SUB(CURDATE(), INTERVAL 12 DAY), 60.00),
(1, DATE_SUB(CURDATE(), INTERVAL 45 DAY), 199.99),
(3, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 135.00),
(4, DATE_SUB(CURDATE(), INTERVAL 70 DAY), 90.00),
(2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 240.00);

-- Retrieve all customers who placed an order in the last 30 days
SELECT DISTINCT c.id, c.name, c.email, c.address
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Get the total amount of all orders placed by each customer
SELECT c.id, c.name, COALESCE(SUM(o.total_amount), 0.00) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- Add a new discount column to the products table
ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) NOT NULL DEFAULT 0.00;

-- Retrieve the top 3 products with the highest price
SELECT id, name, price, description, discount
FROM products
ORDER BY price DESC
LIMIT 3;

-- Normalize the schema by creating order_items for individual items in each order
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample order items matching the sample orders
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 120.00),
(1, 2, 1, 75.50),
(2, 3, 2, 30.00),
(3, 4, 1, 199.99),
(4, 1, 1, 120.00),
(4, 5, 1, 15.00),
(5, 3, 3, 30.00),
(6, 1, 2, 120.00);

-- Get the names of customers who have ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- Join orders and customers to get customer name and order date for each order
SELECT o.id AS order_id, c.name AS customer_name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- Retrieve orders with a total amount greater than 150.00
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE total_amount > 150.00;

-- Retrieve the average total of all orders
SELECT ROUND(AVG(total_amount), 2) AS average_order_total
FROM orders;