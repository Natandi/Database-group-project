--  First created a bookstore database 

CREATE DATABASE bookstore;

-- Create all the tables

USE bookstore;

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(10, 2),
    publication_date DATE
);

CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    PRIMARY KEY (book_id, author_id)
);

CREATE TABLE book_languages (
    book_id INT,
    language VARCHAR(50),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    PRIMARY KEY (book_id, language)
);


CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255)
);

CREATE TABLE customer_address (
    customer_id INT,
    address VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    PRIMARY KEY (customer_id, address)
);

CREATE TABLE address_status (
    address VARCHAR(255),
    status VARCHAR(50),
    PRIMARY KEY (address, status)
);

CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20)
);

CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    code VARCHAR(10)
);

CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    PRIMARY KEY (order_id, book_id)
);

CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50),
    cost DECIMAL(10, 2)
);  

CREATE TABLE order_history (
    order_id INT,
    shipping_method_id INT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    PRIMARY KEY (order_id, shipping_method_id)
);

CREATE TABLE order_status (
    order_id INT,
    status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    PRIMARY KEY (order_id, status)
);  

-- Insert sample data into the tables

INSERT INTO authors (first_name, last_name) VALUES ('George', 'Orwell');
INSERT INTO books (title, genre, price, publication_date)
VALUES ('1984', 'Dystopian', 9.99, '1949-06-08');
INSERT INTO book_authors (book_id, author_id) VALUES (1, 1);
INSERT INTO book_languages (book_id, language) VALUES (1, 'English');
INSERT INTO publishers (name, address) VALUES ('Penguin Books', '80 Strand, London, WC2R 0RL, UK');
INSERT INTO customers (first_name, last_name, email, phone, address)
VALUES ('John', 'Doe', 'l0V5O@example.com', '1234567890', '123 Main St, Anytown, USA');
INSERT INTO customer_address (customer_id, address) VALUES (1, '123 Main St, Anytown, USA');
INSERT INTO address_status (address, status) VALUES ('123 Main St, Anytown, USA', 'Active');
INSERT INTO address (address, city, state, zip_code) VALUES ('123 Main St', 'Anytown', 'CA', '12345');
INSERT INTO country (name, code) VALUES ('United States', 'US');
INSERT INTO cust_order (customer_id, order_date, total_amount) VALUES (1, '2023-10-01', 29.97);
INSERT INTO order_line (order_id, book_id, quantity) VALUES (1, 1, 3);
INSERT INTO shipping_method (method_name, cost) VALUES ('Standard Shipping', 5.99);
INSERT INTO order_history (order_id, shipping_method_id) VALUES (1, 1);
INSERT INTO order_status (order_id, status) VALUES (1, 'Shipped');

-- Write test queries to verify the data
-- Find all books and their authors
SELECT b.title, a.first_name, a.last_name
FROM books b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN authors a ON ba.author_id = a.author_id;

-- Get all orders and customer names
SELECT co.order_id, c.first_name, c.last_name, co.order_date
FROM cust_order co
JOIN customers c ON co.customer_id = c.customer_id;

-- Set up users and roles

CREATE USER 'book_admin'@'localhost' IDENTIFIED BY 'StrongPass123!';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'book_admin'@'localhost';

CREATE USER 'book_viewer'@'localhost' IDENTIFIED BY 'ViewerPass!';
GRANT SELECT ON bookstore_db.* TO 'book_viewer'@'localhost';
