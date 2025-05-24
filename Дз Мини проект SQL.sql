CREATE DATABASE users_adverts;

CREATE TABLE Users
(
date DATE,
user_id VARCHAR(50),
view_adverts INT
);

	#Задание №1.1
SELECT COUNT(DISTINCT(user_id))
FROM users
WHERE date BETWEEN '2023-11-07' AND '2023-11-15';

	#Задание №1.2
SELECT user_id, view_adverts 
FROM users
ORDER BY view_adverts DESC
LIMIT 1;

	#Задание №1.3
SELECT date, AVG(view_adverts) AS avg_view
FROM users 
GROUP BY date
HAVING COUNT(DISTINCT user_id) > 500
ORDER BY avg_view DESC
LIMIT 1;

	#Задание №1.4
SELECT user_id, COUNT(DISTINCT date) AS LT
FROM users
GROUP BY user_id
ORDER BY LT DESC;

	#Задание №1.5
SELECT user_id, AVG(view_adverts) avg_adverts
FROM users
WHERE user_id IN (
SELECT user_id
FROM users
GROUP BY user_id
HAVING COUNT(DISTINCT date) >= 5)
GROUP BY user_id
ORDER BY avg_adverts DESC
LIMIT 1;

	#Задание №2
CREATE  DATABASE mini_project; 

CREATE TABLE T_TAB1
(
ID INT UNIQUE KEY,
GOODS_TYPE VARCHAR (15),
QUANTITY INT,
AMOUNT INT,
SELLER_NAME VARCHAR (4)
);

	SELECT * FROM t_tab1;
INSERT INTO T_TAB1 
(id, GOODS_TYPE, QUANTITY, AMOUNT, SELLER_NAME) 
VALUES (10,'PRINTER',1,80000,'MIKE');

CREATE TABLE T_TAB2
(
ID INT UNIQUE KEY,
NAME VARCHAR (10),
SALARY INT,
AGE INT
);
	SELECT * FROM t_tab2;
INSERT INTO T_TAB2 (id, name, salary, age) 
VALUES (5,'RITA',120000,29);

	#Задание №2.1
SELECT DISTINCT(GOODS_TYPE) FROM t_tab1; 
# Ответ 4 
	
    #Задание №2.2
SELECT GOODS_TYPE, SUM(QUANTITY) AS sum_quantity, SUM(AMOUNT) AS sum_amount 
FROM t_tab1
WHERE GOODS_TYPE = 'MOBILE PHONE'
GROUP BY GOODS_TYPE;
# Ответ кол-во 5, суммарная стоимость 640000
	
    #Задание №2.3
SELECT * FROM t_tab2
WHERE SALARY > 100000;
# Ответ 3
	
    #Задание №2.4
SELECT MAX(age), MIN(age), MAX(SALARY), MIN(SALARY)
FROM t_tab2;
	
    #Задание №2.5
SELECT GOODS_TYPE, ROUND(AVG(QUANTITY), 1) AS 'Среднее кол-во'
FROM t_tab1
WHERE GOODS_TYPE = 'KEYBOARD'
UNION
SELECT GOODS_TYPE,ROUND(AVG(QUANTITY), 1) AS 'Среднее кол-во'
FROM t_tab1
WHERE GOODS_TYPE = 'PRINTER';
	
    #Задание №2.6
SELECT SELLER_NAME, SUM(AMOUNT) AS 'Суммарная стоимость'
FROM t_tab1	
GROUP BY SELLER_NAME;

	#Задание №2.7
SELECT t1.SELLER_NAME, t1.GOODS_TYPE, t1.QUANTITY, t1.AMOUNT,t2.SALARY, t2.AGE 
FROM t_tab1 t1
JOIN t_tab2 t2
ON t1.SELLER_NAME = t2.NAME
WHERE t2.NAME = 'MIKE';

	#Задание №2.8
SELECT t2.NAME, t1.QUANTITY
FROM t_tab2 t2
LEFT JOIN t_tab1 t1
ON t1.SELLER_NAME = t2.NAME
WHERE t1.SELLER_NAME IS NULL;

	#Задание №2.9
SELECT name, salary 
FROM t_tab2
WHERE age < 26;
# Ответ 3

	#Задание №2.10
SELECT * FROM T_TAB1 t1
JOIN T_TAB2 t2 
ON t2.name = t1.seller_name
WHERE t2.name = 'RITA';
# Ответ запрос вернул 0 строк так как этот сотрудник ничего не продал








