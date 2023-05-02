CREATE DATABASE instagrame;
USE instagrame;


select current_date();
-- 1.Find the 5 oldest users. ------
SELECT id, username, created_at
FROM instagrame.users
ORDER BY STR_TO_DATE(created_at, '%d-%m-%Y %H:%i') ASC
LIMIT 5;


-- working query
SELECT id, username, created_at
FROM instagrame.users  
ORDER BY created_at ASC
LIMIT 5;

select * from instagrame.users order by created_at desc;


-- 2.What day of the week do most users register on? 
--  We need to figure out when to schedule an ad campgain? -----------

SELECT 
    DATE(created_at) AS day_of_week,
    COUNT(*) AS num_users_registered
FROM 
    instagrame.users 
GROUP BY 
    day_of_week
ORDER BY 
    num_users_registered DESC
LIMIT 1;

-- 3.We want to target our inactive users with an email campaign. Find the users who have never posted a photo.--

SELECT 
    username
FROM 
     instagrame.users
WHERE 
    id NOT IN (
        SELECT DISTINCT 
            user_id
        FROM 
            instagrame.photos
    );


-- 4.We're running a new contest to see who can get the most likes on a single photo. WHO WON?--
SELECT 
    u.username, 
    p.id, 
    p.image_url, 
    COUNT(l.user_id) AS Total_Likes
FROM 
    instagrame.likes l
    INNER JOIN instagrame.photos p ON l.photo_id = p.id
    INNER JOIN instagrame.users u ON p.user_id = u.id
GROUP BY 
    p.id
ORDER BY 
    Total_Likes DESC
LIMIT 1;

-- WORKING 
SELECT users.username, photos.id, photos.image_url, COUNT(likes.photo_id) AS likes 
FROM instagrame.photos 
JOIN instagrame.likes ON photos.id = likes.photo_id 
JOIN instagrame.users ON likes.user_id = users.id 
GROUP BY photos.id 
ORDER BY likes DESC 
LIMIT 1;

-- 5.Our Investors want to know...How many times does the average user post? (total number of photos/total number of users) --

SELECT ROUND((SELECT COUNT(*) FROM instagrame.photos) / (SELECT COUNT(*) FROM instagrame.users), 2) AS avg_photos_per_user;



-- 6.user ranking by postings higher to lower
SELECT users.username, COUNT(DISTINCT photos.id) AS num_photos
FROM photos 
LEFT JOIN users  ON users.id = photos.user_id
GROUP BY users.id, users.username
ORDER BY num_photos DESC;

-- 7.Total Posts by users (longer versionof SELECT COUNT(*)FROM photos)

SELECT SUM(total_posts_per_user) 
FROM (
  SELECT COUNT(*) AS total_posts_per_user
  FROM photos
  GROUP BY user_id
) AS user_posts;



-- 8.Total numbers of users who have posted at least one time
SELECT COUNT(DISTINCT user_id) AS num_users
FROM instagrame.photos;


-- 9.A brand wants to know which hashtags to use in a post. What are the top 5 most commonly used hashtags? --
SELECT tags.tag_name, COUNT(*) AS num_occurrences
FROM  tags
JOIN photo_tags ON photo_tags.tag_id = tags.id
GROUP BY tags.tag_name
ORDER BY num_occurrences DESC;

-- 10.We have a small problem with bots on our site. Find users who have liked every single photo on the site
SELECT users.id, users.username, COUNT(likes.photo_id) AS total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING COUNT(likes.photo_id) = (SELECT COUNT(*) FROM photos)
ORDER BY total_likes_by_user DESC;



-- 11.We also have a problem with celebrities. Find users who have never commented on a photo
SELECT u.username, c.comment_text
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
WHERE c.comment_text IS NULL;


-- 12.Are we overrun with bots and celebrity accounts? Find the percentage of our users who have either never commented on a photo or have commented on every photo? --

SELECT 
  tableA.total_A AS 'Number Of Users who never commented',
  (tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
  tableC.total_C AS 'Number of Users who liked every photo',
  (tableC.total_C/(SELECT COUNT(*) FROM users))*100 AS '%'
  FROM
(
SELECT COUNT(*) AS total_A FROM
(SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL) AS total_number_of_users_without_comments
) AS tableA
JOIN
(
  SELECT COUNT(*) AS total_B 
  FROM
  (
    SELECT username, comment_text
    FROM users
    LEFT JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING comment_text IS NOT NULL
  ) AS total_number_users_with_comments
) AS tableB
JOIN
(
  SELECT COUNT(*) AS total_C
  FROM
  (
    SELECT username
    FROM users
    LEFT JOIN likes ON users.id = likes.user_id
    GROUP BY users.id
    HAVING COUNT(DISTINCT likes.photo_id) = (SELECT COUNT(*) FROM photos)
  ) AS total_number_of_users_who_liked_all_photos
) AS tableC;


-- 13.Find users who have ever commented on a photo? --
SELECT username, comment_text 
FROM users 
LEFT JOIN comments ON users.id = comments.user_id 
GROUP BY users.id 
HAVING comment_text IS NOT NULL;


-- 14.Are we overrun with bots and celebrity accounts? Find the percentage of our users who have either never commented on a photo or have commented on photos before.

SELECT tableA.total_A AS 'Number Of Users who never commented',
(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
tableB.total_B AS 'Number of Users who commented on photos',
(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
(
SELECT COUNT(*) AS total_A FROM
(SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL) AS total_number_of_users_without_comments
) AS tableA
JOIN
(
SELECT COUNT(*) AS total_B FROM
(SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
)AS tableB

