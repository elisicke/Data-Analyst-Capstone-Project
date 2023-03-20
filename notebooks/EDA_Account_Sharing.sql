-- ACCOUNT SHARING

--  GENERAL CHECKS:
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

-- THRESHOLD:
-- Accounts with more than 6 IP addresses AND more than 9 devices per MONTH 
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS devices_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 AND COUNT(DISTINCT user_agent) >= 9
ORDER BY ip_count DESC;

-- Accounts with more than 6 IP addresses OR more than 10 devices per MONTH 
SELECT DATE_TRUNC('month', date_start) AS trunc_month, account_key, COUNT(DISTINCT ip_hash) AS ip_count, COUNT(DISTINCT user_agent) AS device_count
FROM playbacks
GROUP BY account_key, trunc_month
HAVING COUNT(DISTINCT ip_hash) > 6 OR COUNT(DISTINCT user_agent) >= 10
ORDER BY ip_count DESC;
