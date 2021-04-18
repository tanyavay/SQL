DROP DATABASE IF EXISTS `litres`;
CREATE DATABASE litres;

use litres;

-- Создание таблиц

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  city VARCHAR(100) COMMENT "Город проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";

DROP TABLE IF EXISTS books;
CREATE TABLE books (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  title VARCHAR(100) NOT NULL COMMENT "Название",
  author_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора книги",
  publishing_id INT UNSIGNED NOT NULL COMMENT "Ссылка на издательство",
  genre_id INT UNSIGNED NOT NULL COMMENT "Ссылка на типы книг",
  book_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на жанры",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Книги";

DROP TABLE IF EXISTS book_types;
CREATE TABLE book_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Тип книги",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы книг";

DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  athor_f_name VARCHAR(100) NOT NULL COMMENT "Имя автора",
  athor_l_name VARCHAR(100) NOT NULL COMMENT "Фамилия автора",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Авторы";

DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название жанра",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Жанры";

DROP TABLE IF EXISTS publishing_house;
CREATE TABLE publishing_house (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Издательство",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Издательства";

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора отзыва",
  book_id INT UNSIGNED NOT NULL COMMENT "Ссылка на книгу",
  body TEXT NOT NULL COMMENT "Текст отзыва",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Отзывы";

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  book_id INT UNSIGNED NOT NULL COMMENT "Ссылка на книгу",
  total INT UNSIGNED DEFAULT 1 COMMENT "Количество заказанных позиций",
  status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус заказа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Заказы";

DROP TABLE IF EXISTS order_status;
CREATE TABLE order_status (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  status_type VARCHAR(100) NOT NULL COMMENT "Тип статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статусы заказа";

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
  book_id INT UNSIGNED NOT NULL COMMENT "Ссылка на книгу",
  like_type TINYINT UNSIGNED NOT NULL COMMENT "Идентификатор типа лайка (1 - лайк, 0 - дизлайк)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Лайки";

DROP TABLE IF EXISTS wishlist;
CREATE TABLE wishlist (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  user_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор пользователя',
  book_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на книгу',
  is_read TINYINT(1) DEFAULT NULL COMMENT 'Признак прочтения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Список желаемых книг';

DROP TABLE IF EXISTS price_history;
CREATE TABLE price_history (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  user_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор пользователя',
  book_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на книгу',
  price DECIMAL (11,2) COMMENT 'Цена',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "История цен";

ALTER TABLE price_history
ADD DateTo DATE COMMENT 'Действие цены до даты' AFTER price;

ALTER TABLE price_history
ADD DateStart DATE COMMENT 'Действие цены от даты' AFTER price;


-- Настройка внешних ключей

ALTER TABLE books
  ADD CONSTRAINT books_fk_author_id
    FOREIGN KEY (author_id) REFERENCES authors(id),
  ADD CONSTRAINT books_fk_publishing_id
    FOREIGN KEY (publishing_id) REFERENCES publishing_house(id),
  ADD CONSTRAINT books_fk_genre_id
    FOREIGN KEY (genre_id) REFERENCES genres(id);
   
DESC books;

ALTER TABLE reviews
  ADD CONSTRAINT reviews_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT reviews_fk_book_id
    FOREIGN KEY (book_id) REFERENCES books(id);
   
ALTER TABLE orders
  ADD CONSTRAINT orders_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT orders_fk_book_id
    FOREIGN KEY (book_id) REFERENCES books(id),
  ADD CONSTRAINT orders_fk_status_id
    FOREIGN KEY (status_id) REFERENCES order_status(id);

ALTER TABLE likes
  ADD CONSTRAINT likes_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_fk_book_id
    FOREIGN KEY (book_id) REFERENCES books(id);

ALTER TABLE wishlist
  ADD CONSTRAINT wishlist_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT wishlist_fk_book_id
    FOREIGN KEY (book_id) REFERENCES books(id);

ALTER TABLE price_history
  ADD CONSTRAINT price_history_fk_book_id
    FOREIGN KEY (book_id) REFERENCES books(id);

ALTER TABLE orders
ADD book_type_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на тип книги' AFTER book_id;

ALTER TABLE books
  ADD CONSTRAINT books_fk_book_type_id
    FOREIGN KEY (book_type_id) REFERENCES book_types(id);

-- Создание индексов

-- Поиск по названию книги
CREATE INDEX title_idx ON books(title);

-- Поиск книги по имени и фамилии автора
CREATE INDEX authors_lname_fname_idx ON authors(a_last_name, a_first_name);

-- Поиск книги по жанру
CREATE INDEX genres_genrename_idx ON genres(name);

-- Поиск книги по типу
CREATE INDEX book_types_btname_idx ON book_types(name);

-- Поиск книги по издательству
CREATE INDEX publishing_house_phname_idx ON publishing_house(name);

-- Поиск по свежим отзывам
CREATE INDEX reviews_cat_idx ON reviews(created_at);

-- Поиск по последнним заказам
CREATE INDEX orders_cat_idx ON orders(created_at);

-- Пользователю интересно выводит информацию по статусу заказа
CREATE INDEX order_status_stype_idx ON order_status(status_type);

-- Пользователю интересно знать о непрочитанных книгах из вишлиста
CREATE INDEX wishlist_is_read_idx ON wishlist(is_read);

-- Поиск по типу лайков (лайк/дизлайк)
CREATE INDEX likes_like_type_idx ON likes(like_type);

-- Поиск пользователя по по имени фамилии и городу
CREATE INDEX users_fn_ln_c_idx ON users(first_name, last_name, city);

-- Анализ по городам
CREATE INDEX users_city_idx ON users(city);

-- Для анализа пользователей по возрасту
CREATE INDEX users_birthday_idx ON users(birthday);

-- Для анализа пользователей по половой принадлежности
CREATE INDEX users_gender_idx ON users(gender);

-- Для вывода информации по цене (сортировка или фильтрация)
CREATE INDEX price_history_price_idx ON price_history(price);
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
