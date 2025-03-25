-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.products _menu 
(
    product_id bigserial,
    name character varying(50),
    price numeric(10),
    PRIMARY KEY (product_id)
);

CREATE TABLE IF NOT EXISTS public.cart
(
    product_id integer,
    qty integer,
    PRIMARY KEY (product_id)
);

CREATE TABLE IF NOT EXISTS public.users
(
    user_Id bigserial,
    username character varying(50),
    PRIMARY KEY (user_Id)
);

CREATE TABLE IF NOT EXISTS public.order_header
(
    order_id bigserial,
    user_id integer,
    order_date time with time zone,
    PRIMARY KEY (order_id)
);

CREATE TABLE IF NOT EXISTS public.order_details
(
    order_id integer,
    product_id integer,
    qty integer
);

ALTER TABLE IF EXISTS public.cart
    ADD FOREIGN KEY (product_id)
    REFERENCES public.products _menu  (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_header
    ADD FOREIGN KEY (order_id)
    REFERENCES public.users   (user_Id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_details
    ADD FOREIGN KEY (order_id)
    REFERENCES public.order_header (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_details
    ADD FOREIGN KEY (product_id)
    REFERENCES public."products _menu " (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

------INSERT STATEMENTS----
VALUES 
('Sneaker', '1500.00'),
('Shirt', '400.00'),
('T-shirt', '449.99'),
('Flip-flops', '300.00'), 
('Necklace', '150.00'),
('Smartwatch', '2999.99'),
('Hoodie', '399.99');
SELECT * FROM products_menu;

INSERT INTO users (username)
VALUES 
('Steve'),
('Ronald'),
('Marry'),
('Lettica'),
('Mpho'),
('Vuyani'),
('Bob');
SELECT * FROM users;

--------CheckOut-----
---adding to cart

DO $$
BEGIN
IF EXISTS ( SELECT * FROM cart WHERE product_id = 4) THEN 
UPDATE cart SET qty = qty + 1 WHERE product_id = 4;
ELSE 
INSERT INTO cart(product_id, qty) VALUES(4, 1);
END IF;
END $$
SELECT * FROM cart

SELECT 
cart.product_id,
prod_m.name,
prod_m.price AS unit_price,
cart.qty
FROM cart AS cart
JOIN products_menu AS prod_m
ON cart.product_id = prod_m.product_id;

-- deleting from cart
DO $$
BEGIN
IF EXISTS ( SELECT * FROM cart WHERE product_id = 5 AND qty > 1) THEN 
UPDATE cart SET qty = qty - 1 WHERE product_id = 4;
ELSE 
DELETE  FROM cart WHERE product_id = 4;
END IF;
END $$
SELECT * FROM cart

SELECT 
cart.product_id,
p_m.name,
p_m.price,
cart.qty
FROM cart AS cart
JOIN products_menu AS p_m
ON cart.product_id = p_m.product_id;

-- checkout
INSERT INTO order_header(user_id, order_date)
VALUES 
(6, now());
SELECT * FROM order_header;

SELECT 
od_h.order_id,
od_h.user_id,
users.username,
od_h.order_date
FROM order_header AS od_h JOIN users ON od_h.user_id = users.user_id

INSERT INTO order_details(order_id, product_id, qty)
SELECT
(SELECT MAX(order_id) FROM order_header), product_id, qty 
FROM cart;
DELETE FROM cart;
SELECT * FROM cart

-- single order
SELECT 
od_details.order_id,
users.username,
prod_m.name AS item,
od_details.qty,
prod_m.price AS unit_price,
od_h.order_date
FROM order_details AS od_details JOIN order_header AS od_h ON od_details.order_id = od_h.order_id
JOIN users ON users.user_id = od_h.user_id
JOIN products_menu AS prod_m ON prod_m.product_id = od_details.product_id
WHERE od_details.order_id = 5;
