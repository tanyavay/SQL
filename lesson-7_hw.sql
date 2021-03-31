USE shop;

-- 1. Составьте список пользователей users, которые осуществили хотя бы один
-- заказ orders в интернет магазине.
-- При необходимости загрузить дамп shop.sql

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Геннадий';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 2 FROM products
WHERE name = 'Intel Core i5-7400';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Геннадий';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 2 FROM products
WHERE name = 'Gigabyte H310M S2H';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Наталья';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products
WHERE name IN ('Intel Core i5-7400', 'Gigabyte H310M S2H');

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Иван';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products
WHERE name IN ('AMD FX-8320', 'ASUS ROG MAXIMUS X HERO');

INSERT INTO products (name, description, price)
values ('Logitech MX Master 3', 'Мышь LOGITECH MX Master 3 for business, оптическая, беспроводная', '7999');

INSERT INTO products (name, description, price)
values ('Microsoft Keyboard - Schwarz', 'Эргономичная клавиатура Microsoft Keyboard - Schwarz', '7084');

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

-- 2. Выведите список товаров products и разделов catalogs, который соответствует
-- товару.

SELECT p.id, p.name, p.price, c.name AS catalog
FROM products AS p
-- JOIN catalogs AS c ON p.catalog_id = c.id;
LEFT JOIN catalogs AS c ON p.catalog_id = c.id;
     
-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица 
-- городов cities (label, name). Поля from, to и label содержат английские 
-- названия городов, поле name — русское. Выведите список рейсов flights с
-- русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  label_from VARCHAR(255) COMMENT 'Город отравления',
  label_to VARCHAR(255) COMMENT 'Город прибытия'
) COMMENT = 'Рейсы';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'Код города',
  name VARCHAR(255) COMMENT 'Название города'
) COMMENT = 'Словарь городов';

INSERT INTO flights (label_from, label_to) VALUES
  ('moscow', 'omsk'),
  ('irkutsk', 'kazan'),
  ('novgorod', 'moscow'),
  ('kazan', 'novgorod'),
  ('omsk', 'irkutsk');
     
INSERT INTO cities (label, name) VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

SELECT * FROM flights;

SELECT f.id, c_from.name AS city_from, c_to.name AS city_to
FROM flights AS f
JOIN cities AS c_from ON f.label_from = c_from.label
JOIN cities AS c_to ON f.label_to = c_to.label;