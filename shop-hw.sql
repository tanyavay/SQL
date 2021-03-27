use shop;

-- Операции_задание 1

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
 users (name, birthday_at)
VALUES
 ('Геннадий', '1990-10-05'),
 ('Наталья', '1984-11-12'),
 ('Александр', '1985-05-20'),
 ('Сергей', '1988-02-14'),
 ('Иван', '1998-01-12'),
 ('Мария', '2006-08-29'),
 ('Дмитрий', '1985-12-29'),
 ('Елена', '1990-12-30')
 ;
 
UPDATE
 users
SET
 created_at = NOW(),
 updated_at = NOW();
 
-- Операции_задание 2

TRUNCATE TABLE users;

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56'),
  ('Дмитрий', '1985-12-29', '15.04.2018 18:46', '15.04.2018 18:46'),
  ('Елена', '1990-12-30', '17.01.2017 19:05', '17.01.2017 19:05')
  ;
  
 SELECT * FROM users;
 
-- Вариант_1 с преобразованием
-- 21.10.2016 9:14 -> 2016-10-21 09:14:00

UPDATE users
SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
    updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
    
AlTER TABLE users CHANGE created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
AlTER TABLE users CHANGE updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESCRIBE users;

-- Вариант_2 c добавлением столбцов

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

ALTER TABLE users
  ADD COLUMN created_at_ts DATETIME DEFAULT NOW(), 
  ADD COLUMN updated_at_ts DATETIME DEFAULT NOW();

UPDATE users
   SET created_at_ts = (SELECT str_to_date(created_at, '%d.%m.%Y %k:%i')),
       updated_at_ts = (SELECT str_to_date(updated_at, '%d.%m.%Y %k:%i'));    

ALTER TABLE users
  DROP COLUMN created_at, DROP COLUMN updated_at;	
ALTER TABLE users
  RENAME COLUMN created_at_ts to created_at, 
  RENAME COLUMN updated_at_ts to updated_at;
ALTER TABLE users
  CHANGE COLUMN updated_at updated_at DATETIME DEFAULT NOW() ON UPDATE NOW();

SELECT name, created_at, date_format(created_at, '%j %d.%m.%Y %k %H') 
FROM users;

-- Операции_задание 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые
-- разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения
-- значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);

SELECT * FROM storehouses_products ORDER BY value;
SELECT * FROM storehouses_products ORDER BY value desc;

SELECT * FROM storehouses_products
ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;

SELECT * FROM storehouses_products
ORDER BY CASE WHEN value > 0 then FALSE else TRUE end, value;

SELECT * FROM storehouses_products
ORDER BY value = 0, value;

SELECT ~0 as max_bigint_unsigned, ~0 >> 32 as max_int_unsigned;

-- ORDER BY IF(value > 0, 0, 1), value;
-- ORDER BY value = 0, value;
-- ORDER BY FIELD(value, 0), value;
-- ORDER BY CASE WHEN value = 0 THEN 999999 ELSE value END
-- SELECT ~0 as max_bigint_unsigned, ~0 >> 32 as max_int_unsigned;
-- ORDER BY CASE WHEN value = 0 then 2 else 1 end, value;
-- ORDER BY CASE WHEN value > 0 THEN FALSE ELSE TRUE END, value;

-- Операции_задание 4
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в
-- августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT * FROM users;

SELECT name
  FROM users
  WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');
  
 -- Операции_задание 5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT * FROM catalogs
WHERE id IN (1, 2, 5)
ORDER BY FIELD(id, 1, 2, 5);

SELECT * FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

-- Агрегация_задание_1
-- Подсчитайте средний возраст пользователей в таблице users

SELECT * FROM users;

-- Вариант без учета полных лет 
SELECT avg(YEAR(now()) - YEAR(birthday_at)) AS age
FROM users;

-- Рекомендуемый вариант
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age
FROM users;

-- Сравнение
SELECT name, birthday_at,
  YEAR(now()) - YEAR(birthday_at) age1,
  TIMESTAMPDIFF(YEAR, birthday_at, NOW()) age2
FROM users;
	  
-- Тема Агрегация, задание 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
SELECT
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
  COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;

-- Сравнение дней недели года рождения и текущего года
select name, birthday_at,
  DAYNAME(birthday_at),
  DAYNAME(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))))
from users;

-- Тема Агрегация, задание 3
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы
-- Логарифм произведения равен сумме логарифмов. ln(1*2*3*4*5) = ln(1) + ln(2) + ln(3) + ln(4) + ln(5)
-- Натуральный логарифм LN() в паре с функцией возведения экспоненты в степень EXP() даст произведение
-- То есть от каждого значения в поле id берётся натуральный логарифм, затем считается сумма этих логарифмов
-- и затем экспонента возводится в степень, равную этой сумме.
SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;
SELECT * FROM catalogs;