-- ========================================
-- Домашнє завдання 5: Вкладені запити
-- goit-rdb-hw-05
-- Автор: Kulik Daria
-- ========================================

USE homework_db;

-- ========================================
-- ЗАВДАННЯ 1: Вкладений запит в SELECT
-- ========================================
-- Відобразити таблицю order_details та поле customer_id з таблиці orders
-- для кожного запису з order_details

SELECT 
    od.*,
    (SELECT o.customer_id 
     FROM orders o 
     WHERE o.id = od.order_id) AS customer_id
FROM order_details od;


-- ========================================
-- ЗАВДАННЯ 2: Вкладений запит в WHERE
-- ========================================
-- Відобразити order_details, відфільтрувавши за shipper_id=3 з таблиці orders

SELECT od.*
FROM order_details od
WHERE od.order_id IN (
    SELECT o.id 
    FROM orders o 
    WHERE o.shipper_id = 3
);


-- ========================================
-- ЗАВДАННЯ 3: Вкладений запит в FROM
-- ========================================
-- Вибрати рядки з quantity>10, знайти середнє значення quantity, групуючи за order_id

SELECT 
    order_id,
    AVG(quantity) AS avg_quantity
FROM (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
) AS filtered_orders
GROUP BY order_id;


-- ========================================
-- ЗАВДАННЯ 4: Використання WITH (CTE)
-- ========================================
-- Розв'язати завдання 3 використовуючи оператор WITH

-- Для MySQL 8.0+
WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT 
    order_id,
    AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;


-- Альтернатива для MySQL < 8.0 (без WITH):
-- Створюємо тимчасову таблицю
DROP TEMPORARY TABLE IF EXISTS temp;

CREATE TEMPORARY TABLE temp AS
SELECT order_id, quantity
FROM order_details
WHERE quantity > 10;

SELECT 
    order_id,
    AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- Видаляємо тимчасову таблицю
DROP TEMPORARY TABLE IF EXISTS temp;


-- ========================================
-- ЗАВДАННЯ 5: Створення функції
-- ========================================
-- Створити функцію для ділення двох FLOAT параметрів

DROP FUNCTION IF EXISTS divide_floats;

DELIMITER //

CREATE FUNCTION divide_floats(numerator FLOAT, denominator FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN
    -- Перевірка на ділення на нуль
    IF denominator = 0 THEN
        RETURN NULL;
    ELSE
        RETURN numerator / denominator;
    END IF;
END //

DELIMITER ;

-- Застосування функції до quantity з order_details
-- Ділимо quantity на 2.5 (довільне число)
SELECT 
    id,
    order_id,
    product_id,
    quantity,
    divide_floats(quantity, 2.5) AS divided_quantity
FROM order_details
LIMIT 10;

-- Альтернативний приклад: ділення на 3
SELECT 
    id,
    order_id,
    product_id,
    quantity,
    divide_floats(quantity, 3.0) AS divided_by_three
FROM order_details
WHERE quantity > 20
LIMIT 10;
