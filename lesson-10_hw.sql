-- ����_10_��

-- ������� �� �� vk
USE vk;
-- 1. ���������������� ����� ������� ����� ����������� �������� ����� �
-- �������� ������ ���������� � �������� ����������� �������.

-- ������ ������ �� ���������, �.�. ������ ������ ��� ������� �������� ����� profiles_fk_photo_id
-- CREATE INDEX profiles_photo_id_idx ON profiles(photo_id);

CREATE INDEX likes_like_type_idx ON likes(like_type);
-- ����� �� �����������
CREATE INDEX media_filename_idx ON media(filename);
-- ����� �� ��������� ���������
CREATE INDEX communities_name_idx ON communities(name);
-- ����� �� ���������� ������
CREATE INDEX posts_head_idx ON posts(head);
-- ����� �� ������� ������
CREATE FULLTEXT INDEX posts_body_idx ON posts(body);
-- ����� ����� ������������ ����� �� ������, �������� ������������ ��� ��� ���
CREATE INDEX profiles_is_archived_idx ON posts(is_archived);
-- ������������ ������� �������� ������� ������ �����
CREATE INDEX profiles_created_at_idx ON posts(created_at);
-- ������������ ��� ����� ���� ���������� ������������� ��� ���������
CREATE INDEX profiles_is_read_idx ON messages(is_read);
CREATE FULLTEXT INDEX messages_body_idx ON messages(body);
CREATE INDEX messages_fuid_tuid_cat_idx ON messages(from_user_id, to_user_id, created_at);
CREATE INDEX messages_tuid_fuid_cat_idx ON messages(to_user_id, from_user_id, created_at);
CREATE INDEX profiles_fn_ln_pn_c_idx ON profiles(first_name, last_name, patronymic_name, city);
CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX profiles_country_idx ON profiles(country);

-- �������������� �������
-- https://dev.mysql.com/doc/refman/8.0/en/innodb-fulltext-index.html
-- �������������� �����
-- https://dev.mysql.com/doc/refman/8.0/en/fulltext-search.html

-- 2. ������� �� ������� �������
-- ��������� ������, ������� ����� �������� ��������� �������:
-- ��� ������
-- ������� ���������� ������������� � �������
-- ����� ������� ������������ � ������
-- ����� ������� ������������ � ������
-- ����� ���������� ������������� � ������
-- ����� ������������� � �������
-- ��������� � ���������
-- (����� ���������� ������������� � ������ /  ����� ������������� � �������) * 100

-- ��� ������������� ������� ������ � ������� communities_users
/*
INSERT INTO communities_users (community_id, user_id)
  SELECT c.id, u.id
  FROM communities c
  JOIN users u ON rand()
  ORDER BY rand()
  LIMIT 10;
*/

SELECT * FROM communities_users;

-- ������� 1
SELECT DISTINCT 
  c.name AS group_name,
  COUNT(cu.user_id) OVER() / (SELECT COUNT(*) FROM communities) AS avg_users_in_groups, -- (10 + 5 + 11) / 3
  FIRST_VALUE(CONCAT_WS(" ", p.first_name, p.last_name)) OVER w_community_birthday_desc AS youngest,
  FIRST_VALUE(CONCAT_WS(" ", p.first_name, p.last_name)) OVER w_community_birthday_asc AS oldest,
  COUNT(cu.user_id) OVER w_community AS users_in_group,
  (SELECT COUNT(*) FROM users) AS users_total,
  COUNT(cu.user_id) OVER w_community / (SELECT COUNT(*) FROM users) * 100 AS pct
    FROM communities c
      LEFT JOIN communities_users cu ON cu.community_id = c.id
      LEFT JOIN users u ON u.id = cu.user_id
      LEFT JOIN profiles p ON p.user_id = u.id
      WINDOW w_community AS (PARTITION BY c.id),
             w_community_birthday_desc AS (PARTITION BY c.id ORDER BY p.birthday DESC),
             w_community_birthday_asc AS (PARTITION BY c.id ORDER BY p.birthday)
;

select count(*) from communities;

SELECT DISTINCT 
  c.name AS group_name,
  (SELECT count(*) FROM communities_users) / (SELECT COUNT(*) FROM communities) AS avg_users_in_groups, -- (10 + 5 + 11) / 3
  FIRST_VALUE(CONCAT_WS(" ", p.first_name, p.last_name)) OVER w_community_birthday_desc AS youngest,
  FIRST_VALUE(CONCAT_WS(" ", p.first_name, p.last_name)) OVER w_community_birthday_asc AS oldest,
  COUNT(cu.user_id) OVER w_community AS users_in_group,
  (SELECT COUNT(*) FROM users) AS users_total,
  COUNT(cu.user_id) OVER w_community / (SELECT COUNT(*) FROM users) * 100 AS pct
    FROM communities c
      LEFT JOIN communities_users cu ON cu.community_id = c.id
      LEFT JOIN users u ON u.id = cu.user_id
      LEFT JOIN profiles p ON p.user_id = u.id
      WINDOW w_community AS (PARTITION BY c.id),
             w_community_birthday_desc AS (PARTITION BY c.id ORDER BY p.birthday DESC),
             w_community_birthday_asc AS (PARTITION BY c.id ORDER BY p.birthday)
;

-- comm avg     youngest        oldest  
-- sit	6.5000	Trevor Goyette	Donna Doyle	9	101	8.9109
-- ��������
SELECT p.*
FROM communities_users cu 
JOIN communities c ON c.id = cu.community_id 
JOIN profiles p ON p.user_id = cu.user_id
WHERE c.name = 'sit' 
ORDER BY cu.community_id;

-- ������� 2: � ����� ����� ��� FIRST_VALUE � LAST_VALUE
SELECT DISTINCT
  c.name as community, 
  COUNT(*) OVER () / (SELECT COUNT(*) FROM communities c) AS avg_users,
  FIRST_VALUE(CONCAT(p.first_name, ' ', p.last_name)) OVER w_community_birthday AS youngest,
  LAST_VALUE(CONCAT(p.first_name, ' ', p.last_name))
    OVER (w_community_birthday ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS oldest,
  (COUNT(*) OVER w_community) AS users,
  (SELECT COUNT(p.user_id) FROM profiles p) AS users_in_system,
  (COUNT(*) OVER w_community) / (SELECT COUNT(id) FROM users) * 100 AS 'pct'
FROM communities_users cu 
JOIN profiles p ON cu.user_id = p.user_id
JOIN communities c ON c.id = cu.community_id
  WINDOW w_community AS (PARTITION BY c.id),
  w_community_birthday AS (PARTITION BY cu.community_id ORDER BY p.birthday DESC)
;

SELECT
  c.name as community, 
  COUNT(*) OVER () / (SELECT COUNT(*) FROM communities c) AS avg_users,
  FIRST_VALUE(CONCAT(p.first_name, ' ', p.last_name)) OVER w_community_birthday AS youngest,
  LAST_VALUE(CONCAT(p.first_name, ' ', p.last_name))
    OVER (w_community_birthday ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS oldest,
  (COUNT(*) OVER w_community) AS users,
  (SELECT COUNT(p.user_id) FROM profiles p) AS users_in_system,
  (COUNT(*) OVER w_community) / (SELECT COUNT(id) FROM users) * 100 AS 'pct'
FROM communities_users cu 
JOIN profiles p ON cu.user_id = p.user_id
JOIN communities c ON c.id = cu.community_id
  WINDOW w_community AS (PARTITION BY c.id),
  w_community_birthday AS (PARTITION BY cu.community_id ORDER BY p.birthday DESC)
;