-- ��_����_9

-- 1.� ���� ������ shop � sample ������������ ���� � �� �� ������� ������� ���� ������.
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users.
-- ����������� ����������.

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

-- �������, ���������� ������� ������:
-- 1. ������� DDL(Data Definition Language) (��������, CREATE VIEW)
-- 2. ���������� ��������� � �������� ����� mysql (��������, ALTER USER)
-- 3. ���������� ������������ � ����������� (��������, SET autocommit = 1 ��� LOCK TABLES)
-- 4. �������� ������ (��������, LOAD DATA)
-- 5. ���������������� (��������, ANALYZE TABLE)
-- 6. ���������� (��������, START REPLICA)
-- ��������� �����: https://dev.mysql.com/doc/refman/8.0/en/implicit-commit.html

-- 2.�������� �������������, ������� ������� �������� name ��������
-- ������� �� ������� products � ��������������� �������� �������� name
-- �� ������� catalogs.

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

-- 3.����� ������� ������� � ����������� ����� created_at.
-- � ��� ��������� ���������� ����������� ������ �� ������ 2018 ���� '2018-08-01', '2018-08-04', 
-- '2018-08-16' � 2018-08-17. ��������� ������, ������� ������� ������ ������ ��� �� ������, 
-- ��������� � �������� ���� �������� 1, ���� ���� ������������ � �������� ������� � 0, ���� ��� �����������.

-- ������� � ��������� ��������
truncate TABLE posts;
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, '������ ������', '2018-08-01'),
(NULL, '������ ������', '2018-08-04'),
(NULL, '������ ������', '2018-08-16'),
(NULL, '��������� ������', '2018-08-17');

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

-- ������� � ����������� ���������� CTE (MySQL 8)
-- ���������� ������ ���������� ������� � ����������������� ����������
WITH RECURSIVE sequence AS (
  SELECT 0 AS level
  UNION ALL
  SELECT level + 1 AS value FROM sequence WHERE sequence.level < 30)
SELECT level
FROM sequence;

-- ���������� ���������� �������� ��� ��������� ������ ���
WITH RECURSIVE sequence AS (
  SELECT 0 AS level
  UNION ALL
  SELECT level + 1 AS value FROM sequence WHERE sequence.level < 30
)
SELECT DATE(DATE('2018-08-31') - INTERVAL s.level DAY) AS check_date
FROM `sequence` s

-- ��������� � �������� posts
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

-- ������ ������� ��������� ��������� ���
WITH RECURSIVE date_ranges AS (
  SELECT '2018-08-01' as date
  UNION ALL
  SELECT date + interval 1 day FROM date_ranges WHERE date < '2018-08-31')
SELECT * FROM date_ranges;


-- 4.����� ������� ����� ������� � ����������� ����� created_at. 
-- �������� ������, ������� ������� ���������� ������ �� �������, ��������
-- ������ 5 ����� ������ �������.

DROP TABLE IF EXISTS posts;
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);
-- TRUNCATE TABLE posts;

INSERT INTO posts VALUES
(NULL, '������ ������', '2018-11-01'),
(NULL, '������ ������', '2018-11-02'),
(NULL, '������ ������', '2018-11-03'),
(NULL, '��������� ������', '2018-11-04'),
(NULL, '����� ������', '2018-11-05'),
(NULL, '������ ������', '2018-11-06'),
(NULL, '������� ������', '2018-11-07'),
(NULL, '������� ������', '2018-11-08'),
(NULL, '������� ������', '2018-11-09'),
(NULL, '������� ������', '2018-11-10'),
(NULL, '������������ ������', '2018-11-11'),
(NULL, '����������� ������', '2018-11-12');

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

-- ������� 2 (CTE)
WITH delpst as (SELECT created_at FROM posts ORDER BY created_at DESC LIMIT 5, 1)
SELECT * FROM posts
JOIN delpst
ON posts.created_at <= delpst.created_at;

WITH delpst as (SELECT created_at FROM posts ORDER BY created_at DESC LIMIT 5, 1)
DELETE posts FROM posts
JOIN delpst
ON posts.created_at <= delpst.created_at;


-- ������������ ������� �� ���� ������������������ MySQL�
-- (��� ���� ��������� �� ������ �������)

-- 1.�������� ���� ������������� ������� ����� ������ � ���� ������ shop.
-- ������� ������������ shop_read ������ ���� �������� ������ ������� �� ������ ������,
-- ������� ������������ shop � ����� �������� � �������� ���� ������ shop.

DROP USER IF EXISTS 'shop_read'@'localhost';
CREATE USER IF NOT EXISTS 'shop_read'@'localhost' identified BY 'password';
GRANT SELECT, SHOW VIEW ON shop.* TO 'shop_read'@'localhost';

DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER IF NOT EXISTS 'shop'@'localhost' identified BY 'password';
GRANT ALL ON shop.* TO 'shop'@'localhost';

SHOW grants FOR 'shop'@'localhost';
SHOW grants FOR 'shop_read'@'localhost';

-- 2. (�� �������) ����� ������� ������� accounts ���������� ��� ������� id, name, password,
-- ���������� ��������� ����, ��� ������������ � ��� ������. �������� �������������
-- username ������� accounts, ��������������� ������ � �������� id � name. ��������
-- ������������ user_read, ������� �� �� ���� ������� � ������� accounts, ������, ��� ��
-- ��������� ������ �� ������������� username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password VARCHAR(255)
);

INSERT INTO accounts (name, password) VALUES
  ('��������', 'Qt3X08VetW'),
  ('�������', 'hvg0b057Br'),
  ('���������', 'a4YGUJjRLk'),
  ('������', 'YYug1IeyWl'),
  ('����', 'oKoo7KXvTE'),
  ('�����', 'w5r4yvfo9f');

CREATE OR REPLACE VIEW username AS
SELECT id, name FROM accounts;

DROP USER IF EXISTS 'user_read'@'localhost';
CREATE USER IF NOT EXISTS 'user_read'@'localhost' identified BY 'password';
GRANT SELECT(id, name) ON shop.username TO 'user_read'@'localhost';

SHOW grants FOR 'user_read'@'localhost';

-- ������������ ������� �� ���� ��������� ��������� � �������, ��������"

-- 1.�������� �������� ������� hello(), ������� ����� ���������� �����������,
-- � ����������� �� �������� ������� �����. � 6:00 �� 12:00 ������� ������
-- ���������� ����� "������ ����", � 12:00 �� 18:00 ������� ������ ����������
-- ����� "������ ����", � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 �
-- "������ ����".

-- *** ��������� ������ ��� ��� ������, ���� �������� ���� � ��������� ��������
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
      RETURN "������ ����";
    WHEN hour BETWEEN 6 AND 11 THEN
      RETURN "������ ����";
    WHEN hour BETWEEN 12 AND 17 THEN
      RETURN "������ ����";
    WHEN hour BETWEEN 18 AND 23 THEN
      RETURN "������ �����";
  END CASE;
END
~~

DELIMITER ;
-- ***

SELECT NOW(), hello();

-- 2.� ������� products ���� ��� ��������� ����: name � ��������� ������ �
-- description � ��� ���������. ��������� ����������� ����� ����� ��� ������ �� ���.
-- ��������, ����� ��� ���� ��������� �������������� �������� NULL �����������. 
-- ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������.
-- ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.

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

-- 3. �������� �������� ������� ��� ���������� ������������� ����� ���������. 
-- ������� ��������� ���������� ������������������, � ������� ������ ����� ����� ����� ���� ���������� �����.
-- 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987
-- ����� ������� FIBONACCI(10) ������ ���������� ����� 55.

DROP FUNCTION FIBONACCI;

DELIMITER //
CREATE FUNCTION FIBONACCI(num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE fs DOUBLE;
  SET fs = SQRT(5);
  RETURN (POW((1 + fs) / 2.0, num) + POW((1 - fs) / 2.0, num)) / fs; -- ������� ����
END//

DELIMITER ;

SELECT FIBONACCI(10);