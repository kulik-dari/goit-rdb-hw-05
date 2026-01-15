# Домашнє завдання 5: Вкладені запити


---

## 📋 Зміст

1. [Завдання 1: Вкладений запит в SELECT](#завдання-1)
2. [Завдання 2: Вкладений запит в WHERE](#завдання-2)
3. [Завдання 3: Вкладений запит в FROM](#завдання-3)
4. [Завдання 4: Використання WITH (CTE)](#завдання-4)
5. [Завдання 5: Створення функції](#завдання-5)

---

## Завдання 1: Вкладений запит в SELECT

### Опис
Відобразити таблицю `order_details` та поле `customer_id` з таблиці `orders` для кожного запису.

### SQL:
```sql
SELECT 
    od.*,
    (SELECT o.customer_id 
     FROM orders o 
     WHERE o.id = od.order_id) AS customer_id
FROM order_details od;
```

### Результат:
518 рядків з додатковою колонкою `customer_id`

**Скриншот:** `p1_nested_select.png`

---

## Завдання 2: Вкладений запит в WHERE

### Опис
Відобразити `order_details`, відфільтрувавши за умовою `shipper_id=3` з таблиці `orders`.

### SQL:
```sql
SELECT od.*
FROM order_details od
WHERE od.order_id IN (
    SELECT o.id 
    FROM orders o 
    WHERE o.shipper_id = 3
);
```

### Результат:
181 рядок (тільки замовлення з Federal Shipping)

**Скриншот:** `p2_nested_where.png`

---

## Завдання 3: Вкладений запит в FROM

### Опис
Вибрати рядки з `quantity>10`, знайти середнє `quantity`, групуючи за `order_id`.

### SQL:
```sql
SELECT 
    order_id,
    AVG(quantity) AS avg_quantity
FROM (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
) AS filtered_orders
GROUP BY order_id;
```

### Результат:
175 замовлень з середніми значеннями

**Скриншот:** `p3_nested_from.png`

---

## Завдання 4: WITH (CTE)

### Опис
Розв'язати завдання 3 використовуючи `WITH`.

### SQL:
```sql
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
```

### Результат:
175 замовлень (такий самий як у Завданні 3)

**Скриншот:** `p4_with_cte.png`

---

## Завдання 5: Функція divide_floats

### Опис
Створити функцію для ділення двох FLOAT параметрів.

### SQL:
```sql
DROP FUNCTION IF EXISTS divide_floats;

DELIMITER //

CREATE FUNCTION divide_floats(numerator FLOAT, denominator FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN
    IF denominator = 0 THEN
        RETURN NULL;
    ELSE
        RETURN numerator / denominator;
    END IF;
END //

DELIMITER ;

SELECT 
    id,
    quantity,
    divide_floats(quantity, 2.5) AS divided_quantity
FROM order_details
LIMIT 10;
```

### Результат:
10 рядків з оригінальною та поділеною кількістю

**Скриншот:** `p5_function.png`

---

## 📁 Файли

- **homework5_queries.sql** - всі SQL запити
- **README.md** - документація
- **p1_nested_select.png** - Завдання 1
- **p2_nested_where.png** - Завдання 2
- **p3_nested_from.png** - Завдання 3
- **p4_with_cte.png** - Завдання 4
- **p5_function.png** - Завдання 5

---
