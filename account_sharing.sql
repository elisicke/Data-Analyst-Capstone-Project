SELECT *
FROM playbacks p;

-- checking null values ip and devices

SELECT COUNT(*)
FROM playbacks p 
WHERE ip_hash IS NULL;

SELECT COUNT(*)
FROM playbacks p 
WHERE user_agent IS NULL;

-- checking null values for devices 

SELECT "playback_ID", device
FROM playbacks p
WHERE device IS NULL;

SELECT COUNT(*)
FROM playbacks p 
WHERE device IS NULL;
--> no null values found anymore (:

-- IP addresses per account

SELECT COUNT(DISTINCT ip_hash) AS total, account_key 
FROM playbacks
GROUP BY account_key
ORDER BY total DESC;

-- Accounts with more than 72 IP addresses 

SELECT COUNT(DISTINCT ip_hash) AS total, account_key 
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT ip_hash) >= 72
ORDER BY total DESC;
--> List

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT ip_hash) >= 72;
--> 35 accounts


-- Devices per account

SELECT COUNT(DISTINCT user_agent) AS total, account_key 
FROM playbacks
GROUP BY account_key
ORDER BY total DESC;


-- Accounts with more than 20 different devices

SELECT COUNT(DISTINCT user_agent) AS total, account_key 
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20
ORDER BY total DESC;
--> List

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20;
--> 592 accounts

-- Accounts with more than 72 IP addresses and more than 20 different devices

SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT user_agent) AS cnt_devices, COUNT(DISTINCT ip_hash) AS cnt_ip, account_key
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List of accounts

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72;
--> 25 accounts

-- Joining with Subscriptions to add info

SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT pb.user_agent) AS cnt_devices, COUNT(DISTINCT pb.ip_hash) AS cnt_ip, pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start 
FROM playbacks pb
INNER JOIN subscriptions sb
	    ON pb.subscription_key = sb.subscription_key
GROUP BY pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start 
HAVING COUNT(DISTINCT pb.user_agent) >= 20 AND COUNT(DISTINCT pb.ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List  of accounts with info, only 16 rows??

-- Also joining with Accounts to add more infos

SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT pb.user_agent) AS cnt_devices, COUNT(DISTINCT pb.ip_hash) AS cnt_ip, pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start, ac.city_original
FROM playbacks pb
INNER JOIN subscriptions sb
	    ON pb.subscription_key = sb.subscription_key
INNER JOIN accounts ac
			ON pb.account_key = ac.account_key 
GROUP BY pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start, ac.city_original
HAVING COUNT(DISTINCT pb.user_agent) >= 20 AND COUNT(DISTINCT pb.ip_hash) >= 72
ORDER BY total_playbacks DESC;

-- Checking null values city_clean
SELECT city_clean, city_original 
FROM accounts
WHERE city_clean IS NULL;
--> List

SELECT COUNT(*)
FROM accounts
WHERE city_clean IS NULL;
--> 1857 null values


