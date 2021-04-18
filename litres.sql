DROP DATABASE IF EXISTS `litres`;
CREATE DATABASE litres;

use litres;

-- �������� ������

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  first_name VARCHAR(100) NOT NULL COMMENT "��� ������������",
  last_name VARCHAR(100) NOT NULL COMMENT "������� ������������",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "�����",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "�������",
  gender CHAR(1) NOT NULL COMMENT "���",
  birthday DATE COMMENT "���� ��������",
  city VARCHAR(100) COMMENT "����� ����������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������������";

DROP TABLE IF EXISTS books;
CREATE TABLE books (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  title VARCHAR(100) NOT NULL COMMENT "��������",
  author_id INT UNSIGNED NOT NULL COMMENT "������ �� ������ �����",
  publishing_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������",
  genre_id INT UNSIGNED NOT NULL COMMENT "������ �� ���� ����",
  book_type_id INT UNSIGNED NOT NULL COMMENT "������ �� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "�����";

DROP TABLE IF EXISTS book_types;
CREATE TABLE book_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  name VARCHAR(100) NOT NULL COMMENT "��� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���� ����";

DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  athor_f_name VARCHAR(100) NOT NULL COMMENT "��� ������",
  athor_l_name VARCHAR(100) NOT NULL COMMENT "������� ������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������";

DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  name VARCHAR(100) NOT NULL COMMENT "�������� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "�����";

DROP TABLE IF EXISTS publishing_house;
CREATE TABLE publishing_house (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  name VARCHAR(100) NOT NULL COMMENT "������������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������������";

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������ ������",
  book_id INT UNSIGNED NOT NULL COMMENT "������ �� �����",
  body TEXT NOT NULL COMMENT "����� ������",
  created_at DATETIME DEFAULT NOW() COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������";

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������",
  book_id INT UNSIGNED NOT NULL COMMENT "������ �� �����",
  total INT UNSIGNED DEFAULT 1 COMMENT "���������� ���������� �������",
  status_id INT UNSIGNED NOT NULL COMMENT "������ �� ������ ������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������";

DROP TABLE IF EXISTS order_status;
CREATE TABLE order_status (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  status_type VARCHAR(100) NOT NULL COMMENT "��� �������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������� ������";

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������������� ������������",
  book_id INT UNSIGNED NOT NULL COMMENT "������ �� �����",
  like_type TINYINT UNSIGNED NOT NULL COMMENT "������������� ���� ����� (1 - ����, 0 - �������)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "�����";

DROP TABLE IF EXISTS wishlist;
CREATE TABLE wishlist (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
  user_id INT UNSIGNED NOT NULL COMMENT '������������� ������������',
  book_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
  is_read TINYINT(1) DEFAULT NULL COMMENT '������� ���������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������'
) COMMENT '������ �������� ����';

DROP TABLE IF EXISTS price_history;
CREATE TABLE price_history (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
  user_id INT UNSIGNED NOT NULL COMMENT '������������� ������������',
  book_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
  price DECIMAL (11,2) COMMENT '����',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������� ���";

ALTER TABLE price_history
ADD DateTo DATE COMMENT '�������� ���� �� ����' AFTER price;

ALTER TABLE price_history
ADD DateStart DATE COMMENT '�������� ���� �� ����' AFTER price;


-- ��������� ������� ������

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
ADD book_type_id INT UNSIGNED NOT NULL COMMENT '������ �� ��� �����' AFTER book_id;

ALTER TABLE books
  ADD CONSTRAINT books_fk_book_type_id
    FOREIGN KEY (book_type_id) REFERENCES book_types(id);

-- �������� ��������

-- ����� �� �������� �����
CREATE INDEX title_idx ON books(title);

-- ����� ����� �� ����� � ������� ������
CREATE INDEX authors_lname_fname_idx ON authors(a_last_name, a_first_name);

-- ����� ����� �� �����
CREATE INDEX genres_genrename_idx ON genres(name);

-- ����� ����� �� ����
CREATE INDEX book_types_btname_idx ON book_types(name);

-- ����� ����� �� ������������
CREATE INDEX publishing_house_phname_idx ON publishing_house(name);

-- ����� �� ������ �������
CREATE INDEX reviews_cat_idx ON reviews(created_at);

-- ����� �� ���������� �������
CREATE INDEX orders_cat_idx ON orders(created_at);

-- ������������ ��������� ������� ���������� �� ������� ������
CREATE INDEX order_status_stype_idx ON order_status(status_type);

-- ������������ ��������� ����� � ������������� ������ �� ��������
CREATE INDEX wishlist_is_read_idx ON wishlist(is_read);

-- ����� �� ���� ������ (����/�������)
CREATE INDEX likes_like_type_idx ON likes(like_type);

-- ����� ������������ �� �� ����� ������� � ������
CREATE INDEX users_fn_ln_c_idx ON users(first_name, last_name, city);

-- ������ �� �������
CREATE INDEX users_city_idx ON users(city);

-- ��� ������� ������������� �� ��������
CREATE INDEX users_birthday_idx ON users(birthday);

-- ��� ������� ������������� �� ������� ��������������
CREATE INDEX users_gender_idx ON users(gender);

-- ��� ������ ���������� �� ���� (���������� ��� ����������)
CREATE INDEX price_history_price_idx ON price_history(price);
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
