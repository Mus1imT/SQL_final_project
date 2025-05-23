	# Задание 1
SELECT 
    ID_client,
    COUNT(*) AS total_operations,
    SUM(Sum_payment) AS total_amount,
    AVG(Sum_payment) AS avg_check,
    SUM(Sum_payment)/12 AS avg_monthly_amount
FROM transactions 
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'  
GROUP BY ID_client
HAVING COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) = 12 
ORDER BY total_amount DESC;
	# Задание 2
-- a) Cредняя сумма чека в месяц
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    ROUND(AVG(Sum_payment), 2) AS avg_check_per_month
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY DATE_FORMAT(date_new, '%Y-%m');

-- b) Среднее количество операций в месяц
SELECT 
    ROUND(COUNT(*)/12, 1) AS avg_operations_per_month
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01';

-- c) Среднее количество активных клиентов в месяц
SELECT 
    ROUND(AVG(active_clients), 1) AS avg_active_clients_per_month
FROM (
    SELECT 
        DATE_FORMAT(date_new, '%Y-%m') AS month,
        COUNT(DISTINCT ID_client) AS active_clients
    FROM transactions
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY DATE_FORMAT(date_new, '%Y-%m')
) AS monthly_clients;

-- d) Доля от общего количества и суммы операций
SELECT 
    ID_client,
    COUNT(*) AS operations_count,
    ROUND( (COUNT(*) * 100.0)/ (SELECT COUNT(*) FROM transactions WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'), 2) AS operations_percentage,
    SUM(Sum_payment) AS total_amount,
    ROUND( (SUM(Sum_payment) * 100.0) / (SELECT SUM(Sum_payment) FROM transactions WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'), 2) AS amount_percentage
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY ID_client;

-- e) % соотношение M/F/NA в каждом месяце
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    Gender,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY DATE_FORMAT(date_new, '%Y-%m')) AS gender_percent,
    SUM(Sum_payment) * 100.0 / SUM(SUM(Sum_payment)) OVER (PARTITION BY DATE_FORMAT(date_new, '%Y-%m')) AS amount_percent
FROM transactions t
JOIN customers c ON t.ID_client = c.ID_client
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY DATE_FORMAT(date_new, '%Y-%m'), Gender
ORDER BY month, Gender;

	# Задание 3
-- Общая статистика по возрастным группам
SELECT 
    CASE 
        WHEN Age IS NULL THEN 'Unknown'
        WHEN Age < 20 THEN '0-19'
        WHEN Age < 30 THEN '20-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        WHEN Age < 60 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_clients,
    SUM(Total_amount) AS total_spent,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers) AS client_percentage,
    SUM(Total_amount) * 100.0 / (SELECT SUM(Total_amount) FROM customers) AS amount_percentage
FROM customers
GROUP BY age_group
ORDER BY age_group;

-- Поквартальная статистика
SELECT 
    CONCAT(YEAR(date_new), '-Q', QUARTER(date_new)) AS quarter,
    CASE 
        WHEN Age IS NULL THEN 'Unknown'
        WHEN Age < 20 THEN '0-19'
        WHEN Age < 30 THEN '20-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        WHEN Age < 60 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS operations_count,
    AVG(Sum_payment) AS avg_payment,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY CONCAT(YEAR(date_new), '-Q', QUARTER(date_new))) AS quarter_percentage
FROM transactions t
JOIN customers c ON t.ID_client = c.ID_client
GROUP BY quarter, age_group
ORDER BY quarter, age_group;