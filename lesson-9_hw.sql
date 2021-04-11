-- ДЗ_урок_9

-- 1.В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
-- Используйте транзакции.

-- SHOW variables LIKE 'autocommit'
-- SET autocommit=0;

-- drop table if exists sample.users;
-- create table sample.users like shop.users;
-- create table sample.users as select * from shop.users where 1=0;
USE shop;
SELECT * FROM shop.users;

DROP TABLE IF EXISTS sample.users;
create table sample.users like shop.users;

SELECT * FROM sample.users;

START TRANSACTION;
  INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
  DELETE FROM shop.users WHERE id = 1;
COMMIT;
-- ROLLBACK;

-- Команды, вызывающие неявный коммит:
-- 1. Команды DDL(Data Definition Language) (например, CREATE VIEW)
-- 2. Вызывающие изменения в таблицах схемы mysql (например, ALTER USER)
-- 3. Управление транзакциями и блокировами (например, SET autocommit = 1 или LOCK TABLES)
-- 4. Загрузки данных (например, LOAD DATA)
-- 5. Административные (например, ANALYZE TABLE)
-- 6. Репликации (например, START REPLICA)
-- Подробнее здесь: https://dev.mysql.com/doc/refman/8.0/en/implicit-commit.html

-- 2.Создайте представление, которое выводит название name товарной
-- позиции из таблицы products и соответствующее название каталога name
-- из таблицы catalogs.

CREATE OR REPLACE VIEW products_catalogs AS
SELECT
  p.name AS product,
  c.name AS catalog
FROM products AS p
JOIN catalogs AS c ON p.catalog_id = c.id;

SELECT * FROM products_catalogs;

-- https://dev.mysql.com/doc/refman/8.0/en/view-algorithms.html

/*
CREATE TABLE t (id int);
CREATE VIEW v AS SELECT * FROM t WHERE id < 100;

SELECT * FROM v WHERE id > 50;
-- ALGORITHM=TEMPTABLE:
WHERE id < 100 => WHERE id > 50

-- ALGORITHM=MERGE:
WHERE id < 100 AND WHERE id > 50
*/

-- 3.Пусть имеется таблица с календарным полем created_at.
-- В ней размещены разреженые календарные записи за август 2018 года '2018-08-01', '2018-08-04', 
-- '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходной таблице и 0, если она отсутствует.

-- Вариант с временной таблицей
truncate TABLE posts;
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, 'первая запись', '2018-08-01'),
(NULL, 'вторая запись', '2018-08-04'),
(NULL, 'третья запись', '2018-08-16'),
(NULL, 'четвертая запись', '2018-08-17');

-- DROP TABLE last_days;
-- DROP TEMPORARY TABLE last_days;
CREATE TEMPORARY TABLE last_days (
  day INT
);

INSERT INTO last_days VALUES
(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),(11), (12), (13), (14), (15),
(16), (17), (18), (19), (20), (21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

SELECT * FROM posts;
SELECT * FROM last_days;

SELECT
  DATE(DATE('2018-08-31') - INTERVAL l.day DAY) AS day,
  -- p.name,
  NOT ISNULL(p.name) AS order_exists
FROM last_days AS l
LEFT JOIN posts AS p
ON DATE(DATE('2018-08-31') - INTERVAL l.day DAY) = p.created_at
ORDER BY day;

-- Вариант с рекурсивным выражением CTE (MySQL 8)
-- Генерируем нужное количество записей с последовательными значениями
WITH RECURSIVE sequence AS (
  SELECT 0 AS level
  UNION ALL
  SELECT level + 1 AS value FROM sequence WHERE sequence.level < 30)
SELECT level
FROM sequence;

-- Используем полученные значения для генерации списка дат
WITH RECURSIVE sequence AS (
  SELECT 0 AS level
  UNION ALL
  SELECT level + 1 AS value FROM sequence WHERE sequence.level < 30
)
SELECT DATE(DATE('2018-08-31') - INTERVAL s.level DAY) AS check_date
FROM `sequence` s

-- Объединим с таблицей posts
SELECT s.check_date, NOT ISNULL(p.name) order_exists FROM (
WITH RECURSIVE sequence AS (
  SELECT 0 AS level
  UNION ALL
  SELECT level + 1 AS value FROM sequence WHERE sequence.level < 30
)
SELECT DATE(DATE('2018-08-31') - INTERVAL s.level DAY) AS check_date
FROM `sequence` s
) s
LEFT JOIN posts p ON p.created_at = s.check_date
ORDER BY 1
;

-- Другой вариант генерации диапазона дат
WITH RECURSIVE date_ranges AS (
  SELECT '2018-08-01' as date
  UNION ALL
  SELECT date + interval 1 day FROM date_ranges WHERE date < '2018-08-31')
SELECT * FROM date_ranges;


-- 4.Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя
-- только 5 самых свежих записей.

DROP TABLE IF EXISTS posts;
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);
-- TRUNCATE TABLE posts;

INSERT INTO posts VALUES
(NULL, 'первая запись', '2018-11-01'),
(NULL, 'вторая запись', '2018-11-02'),
(NULL, 'третья запись', '2018-11-03'),
(NULL, 'четвертая запись', '2018-11-04'),
(NULL, 'пятая запись', '2018-11-05'),
(NULL, 'шестая запись', '2018-11-06'),
(NULL, 'седьмая запись', '2018-11-07'),
(NULL, 'восьмая запись', '2018-11-08'),
(NULL, 'девятая запись', '2018-11-09'),
(NULL, 'десятая запись', '2018-11-10'),
(NULL, 'одиннадцатая запись', '2018-11-11'),
(NULL, 'двенадцатая запись', '2018-11-12');

SELECT * FROM posts;

SELECT * FROM posts
JOIN (
  SELECT created_at
  FROM posts
  ORDER BY created_at DESC
  LIMIT 5, 1
) AS delpst
ON posts.created_at <= delpst.created_at;

DELETE posts FROM posts
JOIN (
  SELECT created_at
  FROM posts
  ORDER BY created_at DESC
  LIMIT 5, 1
) AS delpst
ON posts.created_at <= delpst.created_at;

SELECT * FROM posts;

-- Вариант 2 (CTE)
WITH delpst as (SELECT created_at FROM posts ORDER BY created_at DESC LIMIT 5, 1)
SELECT * FROM posts
JOIN delpst
ON posts.created_at <= delpst.created_at;

WITH delpst as (SELECT created_at FROM posts ORDER BY created_at DESC LIMIT 5, 1)
DELETE posts FROM posts
JOIN delpst
ON posts.created_at <= delpst.created_at;


-- Практическое задание по теме “Администрирование MySQL”
-- (эта тема изучается по вашему желанию)

-- 1.Создайте двух пользователей которые имеют доступ к базе данных shop.
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
-- второму пользователю shop — любые операции в пределах базы данных shop.

DROP USER IF EXISTS 'shop_read'@'localhost';
CREATE USER IF NOT EXISTS 'shop_read'@'localhost' identified BY 'password';
GRANT SELECT, SHOW VIEW ON shop.* TO 'shop_read'@'localhost';

DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER IF NOT EXISTS 'shop'@'localhost' identified BY 'password';
GRANT ALL ON shop.* TO 'shop'@'localhost';

SHOW grants FOR 'shop'@'localhost';
SHOW grants FOR 'shop_read'@'localhost';

-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password,
-- содержащие первичный ключ, имя пользователя и его пароль. Создайте представление
-- username таблицы accounts, предоставляющее доступ к столбцам id и name. Создайте
-- пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы
-- извлекать записи из представления username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password VARCHAR(255)
);

INSERT INTO accounts (name, password) VALUES
  ('Геннадий', 'Qt3X08VetW'),
  ('Наталья', 'hvg0b057Br'),
  ('Александр', 'a4YGUJjRLk'),
  ('Сергей', 'YYug1IeyWl'),
  ('Иван', 'oKoo7KXvTE'),
  ('Мария', 'w5r4yvfo9f');

CREATE OR REPLACE VIEW username AS
SELECT id, name FROM accounts;

DROP USER IF EXISTS 'user_read'@'localhost';
CREATE USER IF NOT EXISTS 'user_read'@'localhost' identified BY 'password';
GRANT SELECT(id, name) ON shop.username TO 'user_read'@'localhost';

SHOW grants FOR 'user_read'@'localhost';

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1.Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна
-- возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать
-- фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 —
-- "Доброй ночи".

-- *** Выполняем данный код как скрипт, либо выделяем блок и выполняем отдельно
USE shop;

DROP FUNCTION IF EXISTS hello;

DELIMITER ~~

CREATE FUNCTION hello()
RETURNS TINYTEXT NO SQL
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
  CASE
    WHEN hour BETWEEN 0 AND 5 THEN
      RETURN "Доброй ночи";
    WHEN hour BETWEEN 6 AND 11 THEN
      RETURN "Доброе утро";
    WHEN hour BETWEEN 12 AND 17 THEN
      RETURN "Добрый день";
    WHEN hour BETWEEN 18 AND 23 THEN
      RETURN "Добрый вечер";
  END CASE;
END
~~

DELIMITER ;
-- ***

SELECT NOW(), hello();

-- 2.В таблице products есть два текстовых поля: name с названием товара и
-- description с его описанием. Допустимо присутствие обоих полей или одного из них.
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS validate_name_description_insert;
DROP TRIGGER IF EXISTS validate_name_description_update;
-- ***
DELIMITER //
CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot INSERT if name & description are NULL';
  END IF;
END//

CREATE TRIGGER validate_name_description_update BEFORE UPDATE ON products FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot UPDATE if name & description are NULL';
  END IF;
END//
DELIMITER ;
-- ***

SELECT * FROM products;

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 9360.00, 2);

UPDATE products
  SET name = NULL, description = NULL
WHERE id = 1;

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('ASUS PRIME Z370-P', 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2);

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2);

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('ASUS PRIME Z370-P', NULL, 9360.00, 2);

SELECT * FROM products;

-- 3. Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность, в которой каждое число равно сумме двух предыдущих чисел.
-- 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP FUNCTION FIBONACCI;

DELIMITER //
CREATE FUNCTION FIBONACCI(num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE fs DOUBLE;
  SET fs = SQRT(5);
  RETURN (POW((1 + fs) / 2.0, num) + POW((1 - fs) / 2.0, num)) / fs; -- Формула Бине
END//

DELIMITER ;

SELECT FIBONACCI(10);