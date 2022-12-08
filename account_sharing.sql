SELECT *
FROM playbacks p;

-- checking null values

SELECT COUNT(*)
FROM playbacks p 
WHERE ip_hash IS NULL;

SELECT COUNT(*)
FROM playbacks p 
WHERE user_agent IS NULL;

-- checking null values for devices 

SELECT 	"playback_ID", device
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

SELECT COUNT (*) AS total, COUNT(DISTINCT user_agent) AS cnt_devices, COUNT(DISTINCT ip_hash) AS cnt_ip, account_key
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72
ORDER BY total DESC;
--> List of accounts

SELECT DISTINCT COUNT(*) OVER () AS TotalRecords
FROM playbacks
GROUP BY account_key
HAVING COUNT(DISTINCT user_agent) >= 20 AND COUNT(DISTINCT ip_hash) >= 72;
--> 25 accounts


