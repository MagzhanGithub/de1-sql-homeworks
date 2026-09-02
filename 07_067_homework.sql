-- 1. Создать представление, которое выводит следующие колонки:
-- order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers и employees.
-- Сделать select к созданному представлению, выведя все записи, где order_date больше 1го января 1997 года.
CREATE OR REPLACE VIEW order_joins AS
SELECT
  order_date, 
  required_date, 
  shipped_date, 
  ship_postal_code, 
  company_name, 
  contact_name, 
  phone, 
  last_name, 
  first_name, 
  title  
FROM orders 
JOIN customers USING(customer_id) 
JOIN employees USING(employee_id);

SELECT *
FROM order_joins
WHERE order_date > '1997-01-01';

-- 2. Создать представление, которое выводит следующие колонки:
-- order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers, employees.
-- Попробовать добавить к представлению (после его создания) колонки ship_country, postal_code и reports_to. Убедиться, что проихсодит ошибка. Переименовать представление и создать новое уже с дополнительными колонками.
-- Сделать к нему запрос, выбрав все записи, отсортировав их по ship_county.
-- Удалить переименованное представление.
CREATE VIEW order_customers_employees AS
SELECT
  order_date, 
  required_date, 
  shipped_date, 
  ship_postal_code,
  company_name, 
  contact_name, 
  phone, 
  last_name, 
  first_name, 
  title
FROM orders 
JOIN customers USING(customer_id)
JOIN employees USING(employee_id);

CREATE OR REPLACE VIEW order_customers_employees AS
SELECT
  order_date, 
  required_date, 
  shipped_date, 
  ship_postal_code,  
  company_name, 
  contact_name, 
  phone, 
  last_name, 
  first_name, 
  ship_country,
  title, 
  customers.postal_code,
  reports_to
FROM orders 
JOIN customers USING(customer_id)
JOIN employees USING(employee_id);

ALTER VIEW order_customers_employees
RENAME TO order_old

CREATE VIEW order_customers_employees AS
SELECT
  order_date, 
  required_date, 
  shipped_date, 
  ship_postal_code,  
  company_name, 
  contact_name, 
  phone, 
  last_name, 
  first_name, 
  ship_country,
  title, 
  customers.postal_code,
  reports_to
FROM orders 
JOIN customers USING(customer_id)
JOIN employees USING(employee_id);

SELECT *
FROM order_customers_employees
ORDER BY ship_country;

DROP VIEW order_old;

-- 3.  Создать представление "активных" (discontinued = 0) продуктов, содержащее все колонки. Представление должно быть защищено от вставки записей, в которых discontinued = 1.
-- Попробовать сделать вставку записи с полем discontinued = 1 - убедиться, что не проходит.
CREATE VIEW products_ne_discontinued AS
SELECT * 
FROM products
WHERE discontinued = 0
WITH LOCAL CHECK OPTION;

INSERT INTO products_ne_discontinued (
  product_name,
  supplier_id,
  category_id,
  quantity_per_unit,
  unit_price,
  units_in_stock,
  units_on_order,
  reorder_level,
  discontinued)
SELECT 
  product_name,
  supplier_id,
  category_id,
  quantity_per_unit,
  unit_price,
  units_in_stock,
  units_on_order,
  reorder_level,
  1
FROM products
LIMIT 1;