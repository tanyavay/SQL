USE vk;

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- Исходник
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

-- Результат

SELECT g.gender_info AS gender, count(l.like_type) as Total_likes
FROM profiles p
JOIN gender g ON g.id = p.gender_id
JOIN likes l ON l.user_id = p.user_id
GROUP by p.gender_id
ORDER BY Total_likes DESC
LIMIT 1;


-- 4. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- Исходник

SELECT * FROM profiles ORDER BY birthday DESC LIMIT 10;

SELECT SUM(likes_total) FROM (
  SELECT (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) 
    AS likes_total
  FROM profiles
  ORDER BY birthday 
  DESC LIMIT 10
) AS user_likes;  

SELECT (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) 
    AS likes_total
  FROM profiles
  ORDER BY birthday 
  DESC LIMIT 10;
 

-- Результат - получилось только с вложенным запросом

SELECT SUM(Likes_total) FROM (
SELECT count(l.like_type) as Likes_total
FROM profiles p
LEFT JOIN likes l ON l.target_id = p.user_id AND l.target_type_id = 2
GROUP BY p.user_id 
ORDER BY birthday 
  DESC LIMIT 10
) AS user_likes;


-- 5. Найти 10 пользователей, которые проявляют наименьшую активность
-- в использовании социальной сети

-- Исходник

SELECT 
  CONCAT(first_name, ' ', last_name) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM media WHERE media.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = profiles.user_id) AS overall_activity 
	  FROM profiles
	  ORDER BY overall_activity
	  LIMIT 10;
 
-- Результат - не понимаю что получилось
	 
SELECT
CONCAT(p.first_name, ' ', p.last_name) AS user,
COUNT(*) AS overall_activity
FROM profiles p
left JOIN likes l ON l.user_id = p.user_id
left JOIN media m ON m.user_id = p.user_id
left JOIN messages ms ON ms.from_user_id = p.user_id
GROUP BY user
ORDER BY overall_activity
LIMIT 10;

-- Список медиафайлов пользователя с количеством реакций -лайков и дизлайков

-- Исходник

SELECT
  m.filename,
  CONCAT(p.first_name, ' ', p.last_name) AS owner,
  count(l.target_id) AS total_likes
FROM media m
JOIN users u ON u.id = m.user_id
JOIN profiles p ON p.user_id = u.id
LEFT JOIN likes l ON l.target_id = m.id AND l.target_type_id = 3
GROUP BY m.id;

-- Решение

SELECT
  m.filename,
  CONCAT(p.first_name, ' ', p.last_name) AS owner,
  sum(if (l.like_type = 1, 1, 0)) AS 'likes',
  sum(if (l.like_type = 0, 1, 0)) AS 'dislikes'
  FROM media m
JOIN users u ON u.id = m.user_id
JOIN profiles p ON p.user_id = u.id
LEFT JOIN likes l ON l.target_id = m.id AND l.target_type_id = 3
GROUP BY m.id;

;
  