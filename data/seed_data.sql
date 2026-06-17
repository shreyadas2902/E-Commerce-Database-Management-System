--Sample Data
USE ecommerce;

INSERT INTO sellers (name, email) VALUES
    ('TechZone',    'contact@techzone.com'),
    ('HomeGoods Co','info@homegoods.com'),
    ('FashionHub',  'hello@fashionhub.com');

INSERT INTO customers (name, email) VALUES
    ('Alice Johnson', 'alice@email.com'),
    ('Bob Smith',     'bob@email.com'),
    ('Carol White',   'carol@email.com');

INSERT INTO products (seller_id, name, category, price, stock) VALUES
    (1, 'Wireless Headphones',  'Electronics',  79.99, 50),
    (1, 'USB-C Hub',            'Electronics',  34.99, 120),
    (2, 'Ceramic Mug Set',      'Home & Kitchen',14.99, 200),
    (2, 'Bamboo Cutting Board', 'Home & Kitchen',24.99, 75),
    (3, 'Linen Tote Bag',       'Fashion',       19.99, 90),
    (3, 'Canvas Sneakers',      'Fashion',       54.99, 40);

--Place a sample order using the stored procedure
CALL place_order(1, 1, 2);  --Alice buys 2 Wireless Headphones
CALL place_order(2, 3, 1);  --Bob buys 1 Ceramic Mug Set
CALL place_order(3, 6, 1);  --Carol buys 1 Canvas Sneakers
