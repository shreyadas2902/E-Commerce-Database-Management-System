--Analytics Queries
USE ecommerce;

--Top 10 products by revenue
SELECT
    p.name                          AS product,
    s.name                          AS seller,
    SUM(oi.quantity)                AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sellers  s ON p.seller_id   = s.seller_id
JOIN orders   o ON oi.order_id   = o.order_id
WHERE o.status != 'cancelled'
GROUP BY p.product_id, s.seller_id
ORDER BY revenue DESC
LIMIT 10;

--Revenue per seller
SELECT
    s.name                          AS seller,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM sellers s
JOIN products   p  ON s.seller_id   = p.seller_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders      o  ON oi.order_id  = o.order_id
WHERE o.status != 'cancelled'
GROUP BY s.seller_id
ORDER BY total_revenue DESC;

--Low stock alert (products with fewer than 10 units)
SELECT
    p.product_id,
    p.name      AS product,
    s.name      AS seller,
    p.stock
FROM products p
JOIN sellers s ON p.seller_id = s.seller_id
WHERE p.stock < 10
ORDER BY p.stock ASC;

--Monthly order volume
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*)                          AS orders,
    ROUND(SUM(total), 2)              AS revenue
FROM orders
WHERE status != 'cancelled'
GROUP BY month
ORDER BY month DESC;
