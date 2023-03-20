-- ACCOUNT SHARING

-- checking null values ip and devices
SELECT COUNT(*)
FROM playbacks p 
WHERE ip_hash IS NULL;

SELECT COUNT(*)
FROM playbacks p 
WHERE user_agent IS NULL;

-- checking null values for devices 
SELECT "playback_id", device
FROM playbacks p
WHERE device IS NULL;

SELECT COUNT(*)
FROM playbacks p 
WHERE device IS NULL;
--> no null values found anymore (:

-- Nr of active accounts
SELECT COUNT(account_key)
FROM accounts;

SELECT COUNT(DISTINCT account_key)
FROM playbacks
WHERE subscription_playback = 1;

-- IP addresses per account
SELECT COUNT(DISTINCT ip_hash) AS total, account_key 
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
ORDER BY total DESC;

-- Average IP's per account
SELECT account_key, COUNT(DISTINCT ip_hash) AS count_ip
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
ORDER BY count_ip DESC;
--> List, turn into subquery:

SELECT ROUND(AVG(count_ip), 1) FROM
(SELECT account_key, COUNT(DISTINCT ip_hash) AS count_ip
FROM playbacks p
WHERE subscription_playback = 1
GROUP BY p.account_key) AS a;

-- Average devices per account
SELECT ROUND(AVG(a.count_devices), 1) FROM
(SELECT account_key, COUNT(DISTINCT user_agent) AS count_devices
FROM playbacks p
WHERE subscription_playback = 1
GROUP BY p.account_key) a;

-- Accounts with more than 72 IP addresses 
SELECT COUNT(DISTINCT ip_hash) AS total, account_key
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT ip_hash) >= 72
ORDER BY total DESC;
--> List

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT ip_hash) >= 72;

-- Devices per account
SELECT COUNT(DISTINCT user_agent) AS total, account_key 
FROM playbacks
GROUP BY account_key
ORDER BY total DESC;

-- Accounts with more than 20 different devices
SELECT COUNT(DISTINCT user_agent) AS total, account_key 
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20
ORDER BY total DESC;
--> List

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20;

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 OR COUNT(DISTINCT ip_hash) >= 72;

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72;

-- Testing inner join
SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT pb.user_agent) AS cnt_devices, COUNT(DISTINCT pb.ip_hash) AS cnt_ip, pb.account_key 
FROM playbacks pb
INNER JOIN subscriptions sb
	    ON pb.subscription_key = sb.subscription_key
GROUP BY pb.account_key 
HAVING COUNT(DISTINCT pb.user_agent) >= 20 AND COUNT(DISTINCT pb.ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> works: has also 24 rows

-- Joining with Subscriptions to add info
SELECT COUNT (*) AS total_playbacks, COUNT(DISTINCT pb.user_agent) AS cnt_devices, COUNT(DISTINCT pb.ip_hash) AS cnt_ip, pb.account_key, sb.subscription_type 
FROM playbacks pb
INNER JOIN subscriptions sb
	    ON pb.subscription_key = sb.subscription_key
GROUP BY pb.account_key, sb.subscription_type 
HAVING COUNT(DISTINCT pb.user_agent) >= 20 AND COUNT(DISTINCT pb.ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List of accounts with info, if more grouping columns added why are there less rows now? Because then less accounts satisfy the conditions.

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
--> List of accounts with more info -> only 16 rows!

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

SELECT account_key, date_start, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
WHERE account_key = '07137caf9a41fe28b9f764a7cdef1b62ade23e8c6012822f010f70d8c5239c7d' AND date_start = '2022-04-25'
GROUP BY account_key, date_start;

SELECT account_key, date_start, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, date_start
ORDER BY ip_count DESC;

--DAY
-- Accounts with more than 2 IP addresses per DAY 
SELECT DATE_TRUNC('day', date_start) AS trunc_day, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, trunc_day
HAVING COUNT(DISTINCT ip_hash) > 2
ORDER BY ip_count DESC;

-- Accounts with more than 3 devices per DAY
SELECT DATE_TRUNC('day', date_start) AS trunc_day, account_key, COUNT(DISTINCT user_agent) AS device_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, trunc_day
HAVING COUNT(DISTINCT user_agent) > 3
ORDER BY device_count DESC;

-- MONTH
-- Accounts with more than 6 IP addresses per MONTH
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6
ORDER BY ip_count DESC;

-- Accounts with more than 10 devices per MONTH
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT user_agent) AS device_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT user_agent) > 10
ORDER BY device_count DESC;

-- Accounts with more than 6 IP addresses AND more than 9 devices per MONTH 
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 AND COUNT(DISTINCT user_agent) >= 9
ORDER BY ip_count DESC;

-- Accounts with more than 6 IP addresses AND more than 10 devices per MONTH 
SELECT COUNT(DISTINCT account_key)
FROM (
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 AND COUNT(DISTINCT user_agent) >= 9
ORDER BY ip_count DESC) AS x;

-- Accounts with more than 6 IP addresses OR more than 10 devices per MONTH 
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS device_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 OR COUNT(DISTINCT user_agent) >= 10
ORDER BY ip_count DESC;

-- YEAR
-- Accounts with more than 36 IP addresses per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_year, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, trunc_year
HAVING COUNT(DISTINCT ip_hash) > 36
ORDER BY ip_count DESC;


-- Accounts with more than 15 devices per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_month, account_key, COUNT(DISTINCT user_agent) AS device_count, COUNT(*) AS playback_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT user_agent) > 15
ORDER BY device_count DESC;

-- Accounts with more than 36 IP addresses AND more than 15 devices per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 36 AND COUNT(DISTINCT user_agent) >= 15
ORDER BY ip_count DESC;

-- Accounts with more than 36 IP addresses OR more than 15 devices per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 36 OR COUNT(DISTINCT user_agent) >= 15
ORDER BY ip_count DESC;


-- OVERALL
-- Accounts with more than 72 IP addresses AND more than 20 different devices OVERALL
SELECT account_key, COUNT (*) AS total_playbacks, COUNT(DISTINCT user_agent) AS devices_count, COUNT(DISTINCT ip_hash) AS ip_count
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72
ORDER BY total_playbacks DESC;

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72;

-- Accounts with more than 72 IP addresses OR more than 20 different devices OVERALL
SELECT account_key, COUNT (*) AS total_playbacks, COUNT(DISTINCT user_agent) AS cdevices_count, COUNT(DISTINCT ip_hash) AS ip_count
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 OR COUNT(DISTINCT ip_hash) >= 72
ORDER BY total_playbacks DESC;

-- Average of IP's per day, month, year per account
SELECT AVG(COUNT(DISTINCT ip_hash)
FROM playbacks;
--> doesn't work like this

SELECT (COUNT(DISTINCT ip_hash) / COUNT(DISTINCT account_key)) AS avg_ip
FROM playbacks;
--> doesn't match with EDA results

-- Accounts with more than 2 playbacks with different IP addresses
SELECT account_key, COUNT(DISTINCT movie_id) AS movies_count, COUNT(DISTINCT ip_hash) AS ip_count
FROM playbacks
GROUP BY account_key	
HAVING COUNT(DISTINCT ip_hash) >= 3
ORDER BY movies_count DESC;
--> not correct

