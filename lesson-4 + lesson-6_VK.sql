use vk;

-- ��_4 ���� - ������� �� �������
-- ������� ������
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������������� ������������",
  target_id INT UNSIGNED NOT NULL COMMENT "������������� �������",
  target_type_id INT UNSIGNED NOT NULL COMMENT "������������� ���� �������",
  like_type TINYINT UNSIGNED NOT NULL COMMENT "������������� ���� ����� (1 - ����, 0 - �������)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "�����";

-- ������� ����� �������� ������
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "�������� ����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���� �������� ������";

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

SELECT * FROM target_types;

-- �������� ������� ������
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ����������� ������ �� ������ ������� messages
INSERT INTO posts (user_id, head, body)
  SELECT user_id, substring(body, 1, locate(' ', body) - 1), body FROM (
    SELECT
      (SELECT id FROM users ORDER BY rand() LIMIT 1) AS user_id,
      (SELECT body FROM messages ORDER BY rand() LIMIT 1) AS body
    FROM messages
  ) p;

SELECT * FROM posts;

-- ��������� �����
-- DELETE FROM likes;

-- ����� ����������
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM messages ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'messages'),
    IF(rand() > 0.5, 0, 1)
  FROM messages -- ����� ������� ����� �������, � ����������� ����������� �������
LIMIT 20;

-- ����� �������������
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'users'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- ����� �����������
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM media ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'media'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- ����� ������
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM posts ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'posts'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- ��������
SELECT * FROM likes;


-- ����_6

-- ��������� ������� ����� � �� vk
-- ��������� ER-��������� � DBeaver (������ ���)
-- ��� ������� ��������

-- ������� ��������� �������
DESC profiles;

-- ��������� ������� �����
ALTER TABLE profiles
  ADD CONSTRAINT profiles_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT profiles_fk_gender_id
    FOREIGN KEY (gender_id) REFERENCES gender(id) ON DELETE SET NULL,
  ADD CONSTRAINT profiles_fk_user_status_id
    FOREIGN KEY (user_status_id) REFERENCES user_statuses(id);

ALTER TABLE communities_users
  ADD CONSTRAINT comm_users_fk_comm_id
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT comm_users_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
 ;
     
-- ��� ������� ���������

-- ������� ��������� �������
DESC messages;

-- ��������� ������� �����
ALTER TABLE messages
  ADD CONSTRAINT messages_fk_from_user_id 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_fk_to_user_id 
    FOREIGN KEY (to_user_id) REFERENCES users(id);
    
-- ��������� ER-��������� � DBeaver (��������� �����)

-- ���� ����� �������
ALTER TABLE table_name DROP FOREIGN KEY constraint_name;
ALTER TABLE messages DROP FOREIGN KEY messages_from_user_id_fk;
ALTER TABLE messages DROP FOREIGN KEY messages_to_user_id_fk;

-- ������� �� ������ ���� ������ vk
USE vk;

-- �������� ������ ������������
SELECT * FROM users WHERE id = 3;

-- �������� � ������� �����������
SELECT * FROM profiles;

SELECT * FROM users;

SELECT
  id,
 (SELECT first_name FROM profiles WHERE user_id = 3) AS FirstName,
 (SELECT last_name FROM profiles WHERE user_id = 3) AS LastName,
 (SELECT city FROM profiles WHERE user_id = 3) AS City,
 (SELECT filename FROM media WHERE id=
   (SELECT photo_id FROM profiles WHERE user_id = 3)
 ) AS Photo
FROM users WHERE id = 3;

-- ����������� ������� (user_id = users.id)
SELECT
  id,
 (SELECT first_name FROM profiles WHERE user_id = users.id) AS FirstName,
 (SELECT last_name FROM profiles WHERE user_id = users.id) AS LastName,
 (SELECT city FROM profiles WHERE user_id = users.id) AS City,
 (SELECT filename FROM media WHERE id=
   (SELECT photo_id FROM profiles WHERE user_id = users.id)
 ) AS Photo
FROM users WHERE id = 3;

-- ���������� ������ (����������)
SELECT
  u.id,
 (SELECT p.first_name FROM profiles p WHERE p.user_id = u.id) AS FirstName,
 (SELECT last_name FROM profiles p WHERE p.user_id = u.id) AS LastName,
 (SELECT city FROM profiles p WHERE p.user_id = u.id) AS City,
 (SELECT m.filename FROM media m WHERE m.id=
   (SELECT photo_id FROM profiles p WHERE p.user_id = u.id)
 ) AS Photo
FROM users u WHERE id = 3;

-- �������� ���������� ������������
SELECT * FROM media;
SELECT * FROM media_types;

SELECT * FROM media
WHERE user_id = 2
AND media_type_id = (SELECT id FROM media_types mt WHERE mt.name = 'Image')
;

-- �������� ������� �� ���������� ���������� �������������
SELECT CONCAT(
  '������������ ', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM profiles WHERE user_id = media.user_id),
  ' ������� ���� ', 
  filename, ' ',
  created_at) AS news
    FROM media
    WHERE user_id = 2
    AND media_type_id = ( SELECT id FROM media_types WHERE name = 'Image')
ORDER BY created_at desc
;

-- ����� ���� ����������� 10 ����� ������� �����������
SELECT user_id, filename, size 
  FROM media
  ORDER BY size DESC
  LIMIT 10;

-- ������� ������ � ���������� ������ ��� ��� ������
SELECT
  (SELECT CONCAT(first_name, ' ', last_name) 
    FROM profiles p WHERE p.user_id = m.user_id) AS owner,
  filename,
  size 
    FROM media m
    ORDER BY size DESC
    LIMIT 10;

DESC friendship;
-- �������� ������ ������������ � ���� ������ ��������� ������
SELECT * FROM friendship WHERE user_id = 4 OR friend_id = 4;

SELECT friend_id FROM friendship WHERE user_id = 4
UNION
SELECT user_id FROM friendship WHERE friend_id = 4;

-- �������� ������ ������ � �������� ��������
SELECT * FROM friendship_statuses;

-- ������� 1
(SELECT friend_id 
  FROM friendship 
  WHERE user_id = 6 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Approved'
    )
)
UNION
(SELECT user_id 
  FROM friendship 
  WHERE friend_id = 6 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Approved'
    )
);

-- ������� 2
SELECT friend_id FROM (
  SELECT friend_id, status_id FROM friendship WHERE user_id = 6
  UNION
  SELECT user_id, status_id FROM friendship WHERE friend_id = 6
) AS F WHERE status_id = (
  SELECT id FROM friendship_statuses WHERE name = 'Approved'
);

SELECT
  friend_id,
  (SELECT first_name FROM profiles WHERE user_id = friend_id) AS name
FROM (
  SELECT friend_id, status_id FROM friendship WHERE user_id = 6
  UNION
  SELECT user_id, status_id FROM friendship WHERE friend_id = 6
) AS F WHERE status_id = (
  SELECT id FROM friendship_statuses WHERE name = 'Approved'
);

SELECT first_name FROM profiles WHERE user_id IN (
  SELECT
    friend_id
  FROM (
    SELECT friend_id, status_id FROM friendship WHERE user_id = 6
    UNION
    SELECT user_id, status_id FROM friendship WHERE friend_id = 6
  ) AS F WHERE status_id = (
    SELECT id FROM friendship_statuses WHERE name = 'Approved'
  )
);

-- �������� ���������� ������
SELECT filename FROM media
WHERE user_id IN (
  (SELECT friend_id 
  FROM friendship
  WHERE user_id = 6 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Approved'
    )
  )
  UNION
  (SELECT user_id 
    FROM friendship 
    WHERE friend_id = 6 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Approved'
    )
  )
);

SELECT filename FROM media
WHERE user_id IN (
SELECT friend_id FROM (
  SELECT friend_id, status_id FROM friendship WHERE user_id = 6
  UNION
  SELECT user_id, status_id FROM friendship WHERE friend_id = 6
) AS F WHERE status_id = (
  SELECT id FROM friendship_statuses WHERE name = 'Approved'
)
);


-- ���������� �������������, ����� ���������� ����� ����������� ������� 
-- ��������� 100��
SELECT user_id, SUM(size) AS total, count(*) 
  FROM media
--  WHERE user_id < 25
  GROUP BY user_id
  HAVING total > 100000000;

SELECT * FROM media;

-- ��� ������������� ������� �������� ������ � ������� media, ��������� ��� �������� ������
-- ����� ����� ��������� LIMIT 
INSERT INTO media (user_id, filename, SIZE, media_type_id)
SELECT user_id, filename, round(100000 + rand() * 1000000),
(SELECT id FROM media_types ORDER BY rand() LIMIT 1)
FROM media
ORDER BY rand() LIMIT 10;
 
-- � �������  
SELECT user_id, SUM(size) AS total
  FROM media
  GROUP BY user_id WITH ROLLUP
  HAVING total > 100000000;  

 SELECT IFNULL(user_id, 'Total'), SUM(size) AS total
  FROM media
  GROUP BY user_id WITH ROLLUP
  HAVING total > 100000000;
 
-- �������� ��������� �� ������������ � � ������������
SELECT from_user_id, to_user_id, body, is_delivered, created_at
  FROM messages
    WHERE from_user_id = 7 OR to_user_id = 7
    ORDER BY created_at DESC;

-- ��������� �� ��������
SELECT from_user_id, 
  to_user_id, 
  body, 
  IF(is_delivered, 'delivered', 'not delivered') AS status,
  is_delivered
    FROM messages
      WHERE (from_user_id = 7 OR to_user_id = 7)
    ORDER BY created_at DESC;
    
-- ����� ������������ �� �������� �����  
SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM profiles
  WHERE first_name LIKE 'M%';

SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM profiles
  WHERE first_name LIKE 'M%' OR first_name LIKE 'K%';

 SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM profiles
  WHERE (first_name LIKE 'S%' OR first_name LIKE 'W%') AND last_name LIKE '%r';

 SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM profiles
  WHERE first_name LIKE 'S%' OR first_name LIKE 'W%' AND last_name LIKE '%r';

-- ���������� ���������� ���������
SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM profiles
  WHERE last_name RLIKE '^(W|S).*r$';

-- ������ ��� ��������� ������ �������� ������������ 
SELECT concat('alter table ', table_name, ' drop constraint ', constraint_name, ';') sql_text
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE constraint_schema = 'vk';

-- ������ ��� ������ ���� ��������� ������������
SELECT *
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE constraint_schema = 'vk';

-- ��_����_6

ALTER TABLE profiles
 ADD CONSTRAINT profiles_fk_photo_id
    FOREIGN KEY (photo_id) REFERENCES media(id);
    
ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT communities_users_fk_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
  
ALTER TABLE friendship
  ADD CONSTRAINT friendship_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_fk_friend_id FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_fk_status_id FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);
 
ALTER TABLE likes
  ADD CONSTRAINT likes_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_fk_target_type_id FOREIGN KEY (target_type_id) REFERENCES target_types(id);
 
ALTER TABLE media
  ADD CONSTRAINT media_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_fk_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);
  
 ALTER TABLE posts
  ADD CONSTRAINT posts_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_fk_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
 
-- 3. ���������� ��� ������ �������� ������ (�����) - ������� ��� �������?
-- ��������� ���������� �� ������� ������������ 
SELECT user_id, count(*) AS total
FROM likes
GROUP BY user_id
;

-- ��������� ��� � ����������� �� ����
SELECT (SELECT gender_id FROM profiles WHERE user_id = likes.user_id) AS gender,
count(*) AS total
FROM likes
GROUP BY gender
;

-- ��������� ����������, �����������, �����������, � ������� 1 ������  
SELECT (
  SELECT (SELECT gender_info FROM gender WHERE id = profiles.gender_id)
  FROM profiles WHERE user_id = likes.user_id
) AS gender,
count(*) AS total
FROM likes
GROUP BY gender
ORDER BY total DESC
LIMIT 1
;

-- 4. ���������� ����� ���������� ������, ������� �������� 10 ����� ������� �������������.

-- ������� ���� ��� ������
SELECT * FROM target_types;

-- �������� ������� � ����������� �� ���� ��������
SELECT * FROM profiles ORDER BY birthday DESC LIMIT 10;

-- ������� ������ (��� �������������)
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'users'),
    IF(rand() > 0.5, 0, 1)
  FROM likes
LIMIT 20;

SELECT * FROM likes;

-- �������� ���������� ������ �� �������
SELECT
  (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) 
  AS likes_total
FROM profiles
ORDER BY birthday DESC
LIMIT 10;

-- ��������� ����� ������� ��������
SELECT SUM(likes_total) FROM (
  SELECT (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) 
    AS likes_total
  FROM profiles
  ORDER BY birthday 
  DESC LIMIT 10
) AS user_likes;  

-- ������ �������
SELECT COUNT(*) FROM likes
  WHERE target_type_id = 2
    AND target_id IN (SELECT * FROM (
      SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
    ) AS sorted_profiles ) 
;

-- 5. ����� 10 �������������, ������� ��������� ���������� ����������
-- � ������������� ���������� ����
SELECT 
  CONCAT(first_name, ' ', last_name) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM media WHERE media.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = profiles.user_id) AS overall_activity 
	  FROM profiles
	  ORDER BY overall_activity
	  LIMIT 10;
 
  
