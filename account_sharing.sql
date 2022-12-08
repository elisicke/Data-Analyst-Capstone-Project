

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
HAVING COUNT(DISTINCT user_agent) >= 20 OR COUNT(DISTINCT ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List of accounts

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 OR COUNT(DISTINCT ip_hash) >= 72;
--> 25 accounts

-- Joining with Subscriptions to add info

SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT pb.user_agent) AS cnt_devices, COUNT(DISTINCT pb.ip_hash) AS cnt_ip, pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start 
FROM playbacks pb
INNER JOIN subscriptions sb
	    ON pb.subscription_key = sb.subscription_key
GROUP BY pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start 
HAVING COUNT(DISTINCT pb.user_agent) >= 20 AND COUNT(DISTINCT pb.ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List of accounts with info, only 16 rows??

-- Also joining with Accounts to add more infos

SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT pb.user_agent) AS cnt_devices, COUNT(DISTINCT pb.ip_hash) AS cnt_ip, pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start, ac.city_clean
FROM playbacks pb
INNER JOIN subscriptions sb
	    ON pb.subscription_key = sb.subscription_key
INNER JOIN accounts ac
			ON pb.account_key = ac.account_key 
GROUP BY pb.account_key, sb.subscription_type, sb.currency, sb.subscription_start, ac.city_clean
HAVING COUNT(DISTINCT pb.user_agent) >= 20 AND COUNT(DISTINCT pb.ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List of accounts with more info

-- Looking deeper into one account

SELECT *
FROM playbacks
WHERE account_key = '177ac8d566f62746f03b5ae939f60f83362beab126b38ba0accba16adec976c2'
ORDER BY date_start;


SELECT CAST(date_start AS date), COUNT(*) AS playback_count
FROM playbacks
WHERE account_key = '177ac8d566f62746f03b5ae939f60f83362beab126b38ba0accba16adec976c2'
GROUP BY CAST(date_start AS date)
ORDER BY date_start;


SELECT CAST(date_start AS date), COUNT(*) AS playback_count
FROM playbacks
WHERE account_key = '177ac8d566f62746f03b5ae939f60f83362beab126b38ba0accba16adec976c2'
GROUP BY CAST(date_start AS date)
ORDER BY playback_count DESC;

-- Looking at playback_count at the same day by account

SELECT CAST(date_start AS date), COUNT(*) AS playback_count, account_key 
FROM playbacks
GROUP BY CAST(date_start AS date), account_key 
ORDER BY playback_count DESC;

SELECT *
FROM playbacks
WHERE account_key = '07137caf9a41fe28b9f764a7cdef1b62ade23e8c6012822f010f70d8c5239c7d' AND date_start = 2022-04-25

-- TODO look at all the devices from the top 25 list