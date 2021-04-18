USE litres;

-- ТОП-3 самых понравившихся книг

SELECT b.id, b.title, COUNT(l.like_type) AS total_likes
FROM likes l
JOIN books b ON l.book_id = b.id
 WHERE l.like_type = 1
 GROUP BY b.id
 ORDER by total_likes DESC
LIMIT 3;
 

-- Вывести список 5 самых молодых наиболее активных пользователей, которые ставят лайки

SELECT u.id, u.birthday, COUNT(l.like_type) AS likes_count
FROM users u
LEFT JOIN likes l ON l.user_id = u.id
 GROUP BY u.id
  ORDER BY u.birthday DESC
  LIMIT 5;

 
 -- Вывести непрочитанные книги из вишлист пользователя 5

SELECT b.id, b.title, bt.name ,w.is_read, p.price, p.created_at
FROM wishlist w
JOIN books b ON w.book_id = b.id AND w.user_id = 5 AND w.is_read = 0
JOIN price_history p ON p.book_id = w.book_id AND p.dateTo is null
JOIN book_types bt ON bt.id = b.book_type_id
ORDER BY b.id;

-- Вывести все оплаченные заказы

SELECT o.id, b.id, b.title, bt.name , o.total, os.status_type, p.price
FROM orders o
JOIN books b ON o.book_id = b.id
JOIN price_history p ON p.book_id = o.book_id AND p.dateTo is null
JOIN book_types bt ON bt.id = b.book_type_id
JOIN order_status os ON o.status_id = os.id AND os.status_type = 'paid'
ORDER BY o.id ASC;

-- Вывсести сумму подтвержденных заказов

SELECT SUM(p.price) AS order_total
FROM orders o
JOIN price_history p ON p.book_id = o.book_id AND p.dateTo is null
JOIN order_status os ON o.status_id = os.id AND os.status_type = 'confirmed'
ORDER BY o.id ASC;

/*SELECT o.id, u.first_name, u.last_name, b.title, bt.name , o.total, os.status_type, p.price
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN books b ON o.book_id = b.id
JOIN price_history p ON p.book_id = o.book_id
JOIN book_types bt ON bt.id = b.book_type_id
JOIN order_status os ON o.status_id = os.id AND os.status_type = 'confirmed'
ORDER BY o.id ASC;*/

-- Представления
 -- 1
CREATE OR REPLACE VIEW book_genres AS
SELECT
  b.title AS books,
  g.name AS genres
FROM books AS b
JOIN genres AS g ON b.genre_id = g.id;

SELECT * FROM book_genres;

 -- 2
 
CREATE OR REPLACE VIEW book_catalog AS
SELECT concat(a.athor_f_name, ' ', a.athor_l_name) as author, b.title as books, g.name genres 
 FROM books b
JOIN genres g ON b.genre_id = g.id
JOIN authors a ON b.author_id = a.id;

SELECT * FROM book_catalog;


CREATE OR REPLACE VIEW all_orders AS
SELECT o.id as order_number, os.status_type as order_status, concat(u.first_name , ' ', u.last_name ) as user_name, u.city, b.title as book_title, bt.name as book_type , o.total, p.price
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN books b ON o.book_id = b.id
JOIN price_history p ON p.book_id = o.book_id AND p.dateTo is null
JOIN book_types bt ON bt.id = b.book_type_id
JOIN order_status os ON o.status_id = os.id
ORDER by os.status_type DESC;

SELECT * FROM all_orders;

-- триггеры

update price_history set datestart = now() - interval 7000 day;
commit;

INSERT INTO `price_history` (`id`,`book_id`, `price`, `DateStart`, `DateTo`) VALUES (131, 1, '800', current_timestamp, null);
INSERT INTO `price_history` (`id`,`book_id`, `price`, `DateStart`, `DateTo`) VALUES (132, 2, '800', current_timestamp, null);
INSERT INTO `price_history` (`id`,`book_id`, `price`, `DateStart`, `DateTo`) VALUES (133, 3, '800', current_timestamp, null);

-- не получилось корректно написать триггер, т.к. он не обновляет почему-то DateTo в старой записи
//
CREATE TRIGGER new_price before update ON price_history
FOR EACH ROW
BEGIN
UPDATE price_history ph SET DateTo=NOW() WHERE ph.book_id= new.book_id AND dateTo is null;
insert into price_history values (new.id, new.book_id, new.price, current_timestamp, null);
END
//

INSERT INTO `price_history` (`id`,`book_id`, `price`, `DateStart`, `DateTo`) VALUES (133, 3, '800', current_timestamp, null);



Drop TRIGGER IF EXISTS new_price ;


-- процедура - количество строк в таблице books

CREATE PROCEDURE num_books (OUT total INT)
BEGIN
  SELECT COUNT(*) INTO total FROM books;
END//

call num_books (@a);
select @a;