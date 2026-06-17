--ACID-Compliant Order Transactions
USE ecommerce;

--Place an order (atomic: insert order + deduct stock)
DELIMITER $$

CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_product_id  INT,
    IN p_quantity    INT
)
BEGIN
    DECLARE v_price     DECIMAL(10, 2);
    DECLARE v_stock     INT;
    DECLARE v_order_id  INT;
    DECLARE v_total     DECIMAL(10, 2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order failed — transaction rolled back.';
    END;

    START TRANSACTION;

    --Check stock and price
    SELECT price, stock INTO v_price, v_stock
    FROM products WHERE product_id = p_product_id FOR UPDATE;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock.';
    END IF;

    SET v_total = v_price * p_quantity;

    --Insert order
    INSERT INTO orders (customer_id, total, status)
    VALUES (p_customer_id, v_total, 'confirmed');

    SET v_order_id = LAST_INSERT_ID();

    --Insert order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_order_id, p_product_id, p_quantity, v_price);

    --Deduct stock
    UPDATE products SET stock = stock - p_quantity
    WHERE product_id = p_product_id;

    COMMIT;

    SELECT v_order_id AS order_id, v_total AS total, 'Order placed successfully' AS message;
END$$

DELIMITER ;

--Cancel an order and restore stock
DELIMITER $$

CREATE PROCEDURE cancel_order(IN p_order_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    --Restore stock for each item in the order
    UPDATE products p
    JOIN order_items oi ON p.product_id = oi.product_id
    SET p.stock = p.stock + oi.quantity
    WHERE oi.order_id = p_order_id;

    --Mark order as cancelled
    UPDATE orders SET status = 'cancelled' WHERE order_id = p_order_id;

    COMMIT;
END$$

DELIMITER ;
