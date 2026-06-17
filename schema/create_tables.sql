--E-Commerce Schema
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

--Sellers
CREATE TABLE sellers (
    seller_id   INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Products
CREATE TABLE products (
    product_id  INT PRIMARY KEY AUTO_INCREMENT,
    seller_id   INT NOT NULL,
    name        VARCHAR(200) NOT NULL,
    category    VARCHAR(100),
    price       DECIMAL(10, 2) NOT NULL,
    stock       INT DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id) ON DELETE CASCADE
);

--Orders
CREATE TABLE orders (
    order_id    INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    status      ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    total       DECIMAL(10, 2) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

--Order Items
CREATE TABLE order_items (
    item_id     INT PRIMARY KEY AUTO_INCREMENT,
    order_id    INT NOT NULL,
    product_id  INT NOT NULL,
    quantity    INT NOT NULL,
    unit_price  DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--Indexes for fast lookups
CREATE INDEX idx_product_seller   ON products(seller_id);
CREATE INDEX idx_product_category ON products(category);
CREATE INDEX idx_order_customer   ON orders(customer_id);
CREATE INDEX idx_order_status     ON orders(status);
CREATE INDEX idx_items_order      ON order_items(order_id);
CREATE INDEX idx_items_product    ON order_items(product_id);
