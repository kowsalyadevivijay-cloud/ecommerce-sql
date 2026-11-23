E-Commerce Database Management System (MySQL)

This project contains a MySQL database schema, sample dataset, and SQL queries designed to manage a simple e-commerce system with customers, orders, products, and normalized order line items.

Database & Tables

Database: ecommerce

customers: Stores customer details (id, name, email, address).

orders: Tracks customer orders (id, customer_id, order_date, total_amount).

products: Stores catalog items (id, name, price, description, plus discount added via ALTER TABLE).

order_items: Normalized junction table linking orders and products (id, order_id, product_id, quantity, unit_price).

Queries Included in ecommerce.sql

Retrieve all customers who placed an order in the last 30 days.

Calculate the total order amount placed by each customer.

Update the price of Product C to 45.00.

Add a discount column to the products table.

Retrieve the top 3 products with the highest price.

Retrieve the names of customers who ordered Product A.

Join orders and customers to display the customer's name and order date for each order.

Retrieve all orders with a total_amount greater than 150.00.

Normalize the schema by creating the order_items table to map products to orders.

Calculate the average total_amount across all orders.

How to Run

Open MySQL Workbench or the MySQL Command Line Client.
