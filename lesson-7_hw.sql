USE shop;

-- 1. ��������� ������ ������������� users, ������� ����������� ���� �� ����
-- ����� orders � �������� ��������.
-- ��� ������������� ��������� ���� shop.sql

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = '��������';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 2 FROM products
WHERE name = 'Intel Core i5-7400';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = '��������';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 2 FROM products
WHERE name = 'Gigabyte H310M S2H';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = '�������';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products
WHERE name IN ('Intel Core i5-7400', 'Gigabyte H310M S2H');

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = '����';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products
WHERE name IN ('AMD FX-8320', 'ASUS ROG MAXIMUS X HERO');

INSERT INTO products (name, description, price)
values ('Logitech MX Master 3', '���� LOGITECH MX Master 3 for business, ����������, ������������', '7999');

INSERT INTO products (name, description, price)
values ('Microsoft Keyboard - Schwarz', '������������ ���������� Microsoft Keyboard - Schwarz', '7084');

SELECT * FROM catalogs;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orders_products;

SELECT id, name, birthday_at FROM users;

SELECT u.id, u.name, u.birthday_at
FROM users AS u
JOIN orders AS o ON u.id = o.user_id;

SELECT u.id, u.name, u.birthday_at
FROM orders AS o
JOIN users AS u ON o.user_id = u.id;

SELECT DISTINCT u.id, u.name, u.birthday_at
FROM users u
JOIN orders o ON u.id = o.user_id;

SELECT DISTINCT u.name
FROM users u
JOIN orders o ON u.id = o.user_id;

-- SELECT DISTINCT u.name
-- FROM users u
-- ...
-- __ LEFT JOIN orders o ON o.user_id = u.id;

-- 2. �������� ������ ������� products � �������� catalogs, ������� �������������
-- ������.

SELECT p.id, p.name, p.price, c.name AS catalog
FROM products AS p
-- JOIN catalogs AS c ON p.catalog_id = c.id;
LEFT JOIN catalogs AS c ON p.catalog_id = c.id;
     
-- 3. (�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� 
-- ������� cities (label, name). ���� from, to � label �������� ���������� 
-- �������� �������, ���� name � �������. �������� ������ ������ flights �
-- �������� ���������� �������.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  label_from VARCHAR(255) COMMENT '����� ����������',
  label_to VARCHAR(255) COMMENT '����� ��������'
) COMMENT = '�����';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT '��� ������',
  name VARCHAR(255) COMMENT '�������� ������'
) COMMENT = '������� �������';

INSERT INTO flights (label_from, label_to) VALUES
  ('moscow', 'omsk'),
  ('irkutsk', 'kazan'),
  ('novgorod', 'moscow'),
  ('kazan', 'novgorod'),
  ('omsk', 'irkutsk');
     
INSERT INTO cities (label, name) VALUES
  ('moscow', '������'),
  ('irkutsk', '�������'),
  ('novgorod', '��������'),
  ('kazan', '������'),
  ('omsk', '����');

SELECT * FROM flights;

SELECT f.id, c_from.name AS city_from, c_to.name AS city_to
FROM flights AS f
JOIN cities AS c_from ON f.label_from = c_from.label
JOIN cities AS c_to ON f.label_to = c_to.label;