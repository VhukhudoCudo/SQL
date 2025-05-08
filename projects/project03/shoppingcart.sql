BEGIN;

-- Create products_menu table
CREATE TABLE IF NOT EXISTS public.products_menu (
    prodcuct_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL CHECK (char_length(name) > 0),
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0)
);

-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
    user_id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE CHECK (char_length(username) > 0)
);

-- Create cart table
CREATE TABLE IF NOT EXISTS public.cart (
    product_id INTEGER NOT NULL PRIMARY KEY,
    qty INTEGER NOT NULL CHECK (qty > 0),
    FOREIGN KEY (product_id) REFERENCES public.products_menu(prodcuct_id)
);

-- Create order_header table
CREATE TABLE IF NOT EXISTS public.order_header (
    order_id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);

-- Create order_details table
CREATE TABLE IF NOT EXISTS public.order_details (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    qty INTEGER NOT NULL CHECK (qty > 0),
    FOREIGN KEY (order_id) REFERENCES public.order_header(order_id),
    FOREIGN KEY (product_id) REFERENCES public.products_menu(prodcuct_id)
);

---INSERTS---

-- Sample Products
INSERT INTO products_menu (name, price) VALUES 
('Sneaker', 1500.00),
('Shirt', 400.00),
('T-shirt', 449.99),
('Flip-flops', 300.00), 
('Necklace', 150.00),
('Smartwatch', 2999.99),
('Hoodie', 399.99);

-- Sample Users
INSERT INTO users (username) VALUES 
('Steve'),
('Ronald'),
('Marry'),
('Lettica'),
('Mpho'),
('Vuyani'),
('Bob');

COMMIT;

-- ========================
--  CART 
-- ========================

-- Add to cart 
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 4) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 4;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (4, 2);
    END IF;
END $$;

-- View cart
SELECT 
    c.product_id,
    p.name,
    p.price AS unit_price,
    c.qty,
    (p.price * c.qty) AS total_price
FROM cart c
JOIN products_menu p ON c.product_id = p.prodcuct_id;

-- Delete from cart 
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 5 AND qty > 1) THEN
        UPDATE cart SET qty = qty - 1 WHERE product_id = 4;
    ELSE
        DELETE FROM cart WHERE product_id = 4;
    END IF;
END $$;

DELETE FROM order_details;
DELETE FROM order_header;
-- ========================
--  CHECKOUT
-- ========================

-- Add order header
INSERT INTO order_header (user_id) VALUES (2);  

-- Add order details from cart
INSERT INTO order_details (order_id, product_id, qty)
SELECT 
    (SELECT MAX(order_id) FROM order_header), 
    product_id, 
    qty
FROM cart;

-- Clear the cart after checkout
DELETE FROM cart;

-- ========================
--  ORDER QUERIES
-- ========================

-- View all orders
SELECT 
    od.order_id,
    u.username,
    pm.name AS item,
    od.qty,
    pm.price AS unit_price,
    (od.qty * pm.price) AS total_price,
    oh.order_date
FROM order_details od
JOIN order_header oh ON od.order_id = oh.order_id
JOIN users u ON oh.user_id = u.user_id
JOIN products_menu pm ON od.product_id = pm.prodcuct_id
ORDER BY od.order_id DESC;

-- View a single order
SELECT 
    od.order_id,
    u.username,
    pm.name AS item,
    od.qty,
    pm.price AS unit_price,
    (od.qty * pm.price) AS total_price,
    oh.order_date
FROM order_details od
JOIN order_header oh ON od.order_id = oh.order_id
JOIN users u ON oh.user_id = u.user_id
JOIN products_menu pm ON od.product_id = pm.prodcuct_id
WHERE od.order_id = 2;

-- View users
SELECT * FROM users;

---TEST CONSTRAINT--
INSERT INTO users (username) VALUES ('');

-- View products
SELECT * FROM products_menu;

---Testing Constraint on product_menu---
INSERT INTO products_menu (name, price) VALUES (NULL, 199.99);

-- View cart
SELECT * FROM cart;

-- View order headers
SELECT * FROM order_header;

-- View order details
SELECT * FROM order_details;




