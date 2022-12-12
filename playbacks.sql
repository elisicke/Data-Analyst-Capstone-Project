
-- Nr of active accounts
SELECT COUNT(DISTINCT account_key)
FROM playbacks
WHERE subscription_playback = 1;
--> 7759 accounts

-- max. IP addresses per account OVERALL
SELECT COUNT(DISTINCT ip_hash) AS total, account_key 
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
ORDER BY total DESC;
--> max. is 235 IP addresses per account

-- Average IP's per account
SELECT account_key, COUNT(DISTINCT ip_hash) AS count_ip
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
ORDER BY count_ip DESC;
--> List, turn into subquery:

SELECT ROUND(AVG(a.count_ip), 1) FROM
(SELECT account_key, COUNT(DISTINCT ip_hash) AS count_ip
FROM playbacks p
WHERE subscription_playback = 1
GROUP BY p.account_key) a;
--> 6.4 IP's per account on average


-- Average devices per account
SELECT ROUND(AVG(a.count_devices), 1) FROM
(SELECT account_key, COUNT(DISTINCT user_agent) AS count_devices
FROM playbacks p
WHERE subscription_playback = 1
GROUP BY p.account_key) a;
--> 7.0 devices per account on average


-- Accounts with more than 72 IP addresses OVERALL with row count
SELECT COUNT(DISTINCT ip_hash) AS total, account_key 
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT ip_hash) >= 72
ORDER BY total DESC;
--> List with 34 rows, count rows:

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT ip_hash) >= 72;
--> 34 accounts


-- max. devices per account
SELECT COUNT(DISTINCT user_agent) AS total, account_key 
FROM playbacks
GROUP BY account_key
ORDER BY total DESC;
--> max. is 100 devices per account


-- Accounts with more than 20 different devices OVERALL with row count
SELECT COUNT(DISTINCT user_agent) AS total, account_key 
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20
ORDER BY total DESC;
--> List, count rows:

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20;
--> 555 accounts


-- OVERALL
-- Accounts with more than 72 IP addresses AND more than 20 different devices OVERALL
SELECT account_key, COUNT (*) AS total_playbacks, COUNT(DISTINCT user_agent) AS devices_count, COUNT(DISTINCT ip_hash) AS ip_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List, count rows:

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72;
--> 24 accounts

-- Accounts with more than 72 IP addresses OR more than 20 different devices OVERALL
SELECT account_key, COUNT (*) AS total_playbacks, COUNT(DISTINCT user_agent) AS devices_count, COUNT(DISTINCT ip_hash) AS ip_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 OR COUNT(DISTINCT ip_hash) >= 72
ORDER BY total_playbacks DESC;
--> List with 565 accounts

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 OR COUNT(DISTINCT ip_hash) >= 72;
--> 565 accounts

--DAY
-- Accounts with more than 2 IP addresses per DAY 
SELECT DATE_TRUNC('day', date_start) AS trunc_day, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_day
HAVING COUNT(DISTINCT ip_hash) > 2
ORDER BY ip_count DESC;
--> List with 126 accounts

-- Accounts with more than 3 devices per DAY
SELECT DATE_TRUNC('day', date_start) AS trunc_day, account_key, COUNT(DISTINCT user_agent) AS device_count, COUNT(*) AS playback_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_day
HAVING COUNT(DISTINCT user_agent) > 3
ORDER BY device_count DESC;
--> List with 16 accounts


-- MONTH
-- Accounts with more than 6 IP addresses per MONTH
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6
ORDER BY ip_count DESC;
--> List with 495 accounts

-- Accounts with more than 10 devices per MONTH
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT user_agent) AS device_count, COUNT(*) AS playback_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT user_agent) > 10
ORDER BY device_count DESC;
--> List with 13 accounts

-- Accounts with more than 6 IP addresses AND more than 10 devices per MONTH 
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 AND COUNT(DISTINCT user_agent) >= 10
ORDER BY ip_count DESC;
--> List with 12 accounts, NA

-- Accounts with more than 6 IP addresses OR more than 10 devices per MONTH 
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS device_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 OR COUNT(DISTINCT user_agent) >= 10
ORDER BY ip_count DESC;
--> List with 500 accounts, NA

-- YEAR
-- Accounts with more than 36 IP addresses per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_year, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(*) AS playback_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_year
HAVING COUNT(DISTINCT ip_hash) > 36
ORDER BY ip_count DESC;
--> List with 83 accounts, stimmt mit Tableau überein

-- Accounts with more than 15 devices per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_month, account_key, COUNT(DISTINCT user_agent) AS device_count, COUNT(*) AS playback_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT user_agent) > 15
ORDER BY device_count DESC;
--> List with 388 accounts

-- Accounts with more than 36 IP addresses AND more than 15 devices per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 36 AND COUNT(DISTINCT user_agent) >= 15
ORDER BY ip_count DESC;
--> List with 33 accounts, NA

-- Accounts with more than 36 IP addresses OR more than 15 devices per YEAR
SELECT DATE_TRUNC('year', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
WHERE subscription_playback = 1
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 36 OR COUNT(DISTINCT user_agent) >= 15
ORDER BY ip_count DESC;
--> List with 530 accounts, NA




