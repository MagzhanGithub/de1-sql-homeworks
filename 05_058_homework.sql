-- 1. Создать таблицу exam с полями:
-- - идентификатора экзамена - автоинкрементируемый, уникальный, запрещает NULL;
-- - наименования экзамена
-- - даты экзамена
CREATE TABLE exam (
	exam_id serial UNIQUE NOT NULL,
	exam_name varchar,
	exam_date date
);

-- 2. Удалить ограничение уникальности с поля идентификатора
ALTER TABLE exam
DROP CONSTRAINT exam_exam_id_key;

-- 3. Добавить ограничение первичного ключа на поле идентификатора
ALTER TABLE exam
ADD CONSTRAINT PK_exam_exam_id PRIMARY KEY(exam_id);

-- 4. Создать таблицу person с полями
-- - идентификатора личности (простой int, первичный ключ)
-- - имя
-- - фамилия
CREATE TABLE person (
	person_id int,
	person_name varchar(50),
	last_name varchar(50),

	CONSTRAINT PK_person_person_id PRIMARY KEY (person_id)
);

-- 5. Создать таблицу паспорта с полями:
-- - идентификатора паспорта (простой int, первичный ключ)
-- - серийный номер (простой int, запрещает NULL)
-- - регистрация
-- - ссылка на идентификатор личности (внешний ключ)
CREATE TABLE passport (
    passport_id INT PRIMARY KEY,
    serial_id INT NOT NULL,
    registration_number VARCHAR(50),
    person_id INT,

    CONSTRAINT FK_passport_person_id FOREIGN KEY (person_id)
    REFERENCES person(person_id)
);

-- 6. Добавить колонку веса в таблицу book (создавали ранее) с ограничением, проверяющим вес (больше 0 но меньше 100)
ALTER TABLE book
ADD COLUMN weight float CHECK (weight > 0 AND weight < 100)

-- 7. Убедиться в том, что ограничение на вес работает (попробуйте вставить невалидное значение)
INSERT INTO book
VALUES (2, 'title', 'isbn', 10, 105);

-- 8. Создать таблицу student с полями:
-- - идентификатора (автоинкремент)
-- - полное имя
-- - курс (по умолчанию 1)
CREATE TABLE student (
    student_id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(50),
    kurs INT NOT NULL DEFAULT 1
);

-- 9. Вставить запись в таблицу студентов и убедиться, что ограничение на вставку значения по умолчанию работает
INSERT INTO student (full_name)
VALUES ('Mark Tven')
RETURNING *;

-- 10. Удалить ограничение "по умолчанию" из таблицы студентов
ALTER TABLE student
ALTER COLUMN kurs DROP DEFAULT;

-- 11. Подключиться к БД northwind и добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products
ADD CONSTRAINT CK_products_unit_price CHECK(unit_price > 0);

-- 12. "Навесить" автоинкрементируемый счётчик на поле product_id таблицы products (БД northwind). 
--Счётчик должен начинаться с числа следующего за максимальным значением по этому столбцу.
ALTER TABLE products
ALTER COLUMN product_id SET DATA TYPE INT,
ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (START WITH 78)

-- 13. Произвести вставку в products (не вставляя идентификатор явно) и убедиться, что автоинкремент работает. 
--Вставку сделать так, чтобы в результате команды вернулось значение, сгенерированное в качестве идентификатора.
INSERT INTO products (
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
  discontinued
FROM products
LIMIT 1;