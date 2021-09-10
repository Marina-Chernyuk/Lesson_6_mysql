USE vk;

/* Задание 1: Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).*/

SELECT count(*) mess, friend FROM 
	(SELECT body, to_user_id AS friend FROM messages WHERE from_user_id = 3
	 UNION
	 SELECT body,from_user_id AS friend FROM messages WHERE to_user_id = 3) AS best_friend
GROUP BY friend
ORDER BY mess DESC
LIMIT 1;


/* Задание 2: Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.*/

-- Подсчет лайков
SELECT SUM(media_id) AS countlikes
 FROM likes;

-- запрос на вывод юзеров младше 10 лет	  
SELECT user_id,
	TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
 FROM profiles
 	 GROUP BY user_id
 	 HAVING age < 10
	 ORDER BY age DESC;
	 
-- Два запроса соединим	(не знаю, правильно или нет) 
SELECT COUNT(*) AS countlikes FROM likes WHERE media_id IN (
	SELECT id FROM media 
	WHERE user_id IN (
		SELECT user_id FROM (
			SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
 FROM profiles
 	 GROUP BY user_id
 	 HAVING age < 10
		) AS user_id		
	));

--  наставник Роман написал такой вариант (результаты двух вариантов скриптов не соврадают)
SELECT COUNT(*)
FROM likes
WHERE media_id IN
(SELECT id
FROM media
WHERE user_id IN
(SELECT user_id
FROM profiles
WHERE birthday > CURDATE() - INTERVAL 10 YEAR));
	  
	  
/* Задание 3: Определить кто больше поставил лайков (всего): мужчины или женщины */

SELECT COUNT(*) AS likes, gender FROM likes, profiles
WHERE likes.user_id = profiles.user_id
GROUP BY gender;	  
