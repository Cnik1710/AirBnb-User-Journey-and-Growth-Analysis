CREATE SCHEMA airbnb;

USE airbnb;

SHOW TABLES;

SELECT * FROM countries;
SELECT * FROM sessions_data;
SELECT * FROM users;

DESC countries;
DESC sessions_data;
DESC users;

-- Q1. Are there any duplicate user IDs in the users table?
SELECT id, COUNT(*)
FROM users
GROUP BY id
HAVING COUNT(*) > 1;

-- Q2. How many total unique users are present in the dataset?
SELECT COUNT(DISTINCT id)
FROM users;

-- Q3. How many users from the users table appear in the sessions table?
SELECT COUNT(DISTINCT u.id)
FROM users u
JOIN sessions_data sd
ON sd.user_id = u.id;

-- Q4. What percentage of users have session activity?
SELECT 
ROUND(COUNT(DISTINCT sd.user_id) * 100.0 / COUNT(DISTINCT u.id), 2) AS session_user_percentage
FROM users u
LEFT JOIN sessions_data sd
ON u.id = sd.user_id;

-- Q5. How many users first accessed Airbnb using an iPhone?
SELECT COUNT(DISTINCT id)
FROM users
WHERE first_device_type = 'iPhone';

-- Q6. What is the distribution of users by first device type?
SELECT first_device_type, COUNT(*) AS users
FROM users
GROUP BY first_device_type
ORDER BY users DESC;

-- Q7. What is the gender distribution of users?
SELECT gender, COUNT(*) AS users
FROM users
GROUP BY gender;

-- Q8. What is the user distribution including unknown or missing gender values?
SELECT
COALESCE(gender,'Unknown') AS gender_group,
COUNT(*) AS users
FROM users
GROUP BY gender_group;

-- Q9. What percentage of users belong to each gender category?
SELECT
gender,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users),2) AS percentage
FROM users
GROUP BY gender;

-- Q10. Which gender group has the highest number of bookings?
SELECT
gender,
COUNT(*) AS bookings
FROM users
WHERE country_destination <> 'NDF'
GROUP BY gender
ORDER BY bookings DESC;

-- Q11. Which signup method is used most frequently by users?
SELECT signup_method, COUNT(*) AS total_users
FROM users
GROUP BY signup_method
ORDER BY total_users DESC;

-- Q12. Which affiliate channels bring the most users?
SELECT first_affiliate_channel, COUNT(*) AS users
FROM users
GROUP BY first_affiliate_channel
ORDER BY users DESC;

-- Q13. Which affiliate channels have the highest booking conversion rates?
SELECT
first_affiliate_channel,
COUNT(*) AS users,
SUM(CASE WHEN country_destination <> 'NDF' THEN 1 ELSE 0 END) AS bookings,
ROUND(
SUM(CASE WHEN country_destination <> 'NDF' THEN 1 ELSE 0 END) * 100.0 /
COUNT(*),2
) AS conversion_rate
FROM users
GROUP BY first_affiliate_channel
ORDER BY conversion_rate DESC;

-- Q14. Which affiliate provider brings the highest number of users?
SELECT affiliate_provider, COUNT(*) AS users
FROM users
GROUP BY affiliate_provider
ORDER BY users DESC;

-- Q15. Which signup application (Web, iOS, Android, etc.) is used the most?
SELECT signup_app, COUNT(*) AS total_users
FROM users
GROUP BY signup_app
ORDER BY total_users DESC;

-- Q16. How many total sessions exist in the dataset?
SELECT COUNT(*) AS total_sessions
FROM sessions_data;

-- Q17. What is the average session duration in seconds?
SELECT AVG(secs_elapsed) AS avg_session_time
FROM sessions_data;

-- Q18. What is the longest session recorded in the dataset?
SELECT MAX(secs_elapsed) AS longest_session
FROM sessions_data;

-- Q19. What are the most common actions performed by users?
SELECT action, COUNT(*) AS action_count
FROM sessions_data
GROUP BY action
ORDER BY action_count DESC;

-- Q20. What are the most common action details recorded in sessions?
SELECT action_detail, COUNT(*) AS action_detail_count
FROM sessions_data
GROUP BY action_detail
ORDER BY action_detail_count DESC;

-- Q21. Which device-action combinations occur most frequently?
SELECT device_type, action_type, COUNT(*) AS total_actions
FROM sessions_data
GROUP BY device_type, action_type
ORDER BY total_actions DESC;

-- Q22. Which users access Airbnb using multiple devices?
SELECT user_id
FROM sessions_data
GROUP BY user_id
HAVING COUNT(DISTINCT device_type) > 1;

-- Q23. How many users use more than one device?
SELECT COUNT(*) AS multi_device_users
FROM (
SELECT user_id
FROM sessions_data
GROUP BY user_id
HAVING COUNT(DISTINCT device_type) > 1
) t;

-- Q24. How many different devices are used per user?
SELECT user_id, COUNT(DISTINCT device_type) AS devices_used
FROM sessions_data
GROUP BY user_id
ORDER BY devices_used DESC;

-- Q25. What is the average number of devices used per user?
SELECT AVG(device_count) AS avg_devices_per_user
FROM (
SELECT COUNT(DISTINCT device_type) AS device_count
FROM sessions_data
GROUP BY user_id
) t;

-- Q26. How much total time does each user spend across all sessions?
SELECT user_id, SUM(secs_elapsed) AS total_time
FROM sessions_data
GROUP BY user_id
ORDER BY total_time DESC;

-- Q27. Who are the top 5 most active users with the highest session counts and at least one session longer than 10000 seconds?
SELECT
user_id,
COUNT(*) AS total_sessions,
MAX(secs_elapsed) AS max_session_time
FROM sessions_data
GROUP BY user_id
HAVING MAX(secs_elapsed) > 10000
ORDER BY total_sessions DESC
LIMIT 5;

-- Q28. What is the average session duration for each device type?
SELECT device_type, AVG(secs_elapsed) AS avg_session_time
FROM sessions_data
GROUP BY device_type
ORDER BY avg_session_time DESC;

-- Q29. Which action types consume the most total time?
SELECT action_type, SUM(secs_elapsed) AS total_time
FROM sessions_data
GROUP BY action_type
ORDER BY total_time DESC;

-- Q30. What is the maximum number of devices used by a single user?
SELECT MAX(device_count)
FROM (
SELECT user_id, COUNT(DISTINCT device_type) AS device_count
FROM sessions_data
GROUP BY user_id
) t;

-- Q31. What is the total session count, and which devices generate the most sessions and total engagement time?
SELECT 
    device_type,
    COUNT(*) AS session_count,
    SUM(secs_elapsed) AS total_time_spent,
    (SELECT COUNT(*) FROM sessions_data) AS total_sessions
FROM sessions_data
GROUP BY device_type
ORDER BY session_count DESC;

-- Q32. Which device type generates the highest number of sessions?
SELECT device_type, COUNT(*) AS session_count
FROM sessions_data
GROUP BY device_type
ORDER BY session_count DESC;