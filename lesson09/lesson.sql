-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

start transaction;
delete
from example.users
where id = 1;
insert into example.users (select * from sample.users where id = 1);
delete
from sample.users
where id = 1;
commit;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее
-- название каталога name из таблицы catalogs.

create view task06 as
select prods.name as prod_name, cats.name as cat_name
from my_shop.products as prods
         join my_shop.catalogs as cats on prods.catalog_id = cats.id;

select *
from my_shop.task06;


-- по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи
-- за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный
-- список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она
-- отсутствует.

create table sparse_dates
(
    date datetime
);

insert into sparse_dates
values ('2018-08-01'),
       ('2018-08-04'),
       ('2018-08-16'),
       ('2018-08-17');



select date_field, if(date_field = DATE(sparse_dates.date), 1, 0)
from (
         SELECT date_field
         FROM (
                  SELECT MAKEDATE(YEAR('2018-08-01'), 1) +
                         INTERVAL (MONTH('2018-08-01') - 1) MONTH +
                         INTERVAL daynum DAY date_field
                  FROM (
                           SELECT t * 10 + u daynum
                           FROM (SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A,
                                (SELECT 0 u
                                 UNION
                                 SELECT 1
                                 UNION
                                 SELECT 2
                                 UNION
                                 SELECT 3
                                 UNION
                                 SELECT 4
                                 UNION
                                 SELECT 5
                                 UNION
                                 SELECT 6
                                 UNION
                                 SELECT 7
                                 UNION
                                 SELECT 8
                                 UNION
                                 SELECT 9) B
                           ORDER BY daynum
                       ) AA
              ) AAA
         WHERE MONTH(date_field) = MONTH('2018-08-01')) as t
         left join sparse_dates on sparse_dates.date = t.date_field
group by date_field
order by date_field;

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
-- "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

SET GLOBAL log_bin_trust_function_creators = 1;


DROP FUNCTION IF EXISTS hello;
CREATE function hello()
    RETURNS VARCHAR(255) NOT DETERMINISTIC
BEGIN
    declare now_time INT;
    SET now_time = HOUR(now());
    IF now_time between 18 and 23 THEN
        return 'Добрый вечер';
    ELSEIF now_time between 00 and 05 THEN
        return 'Доброй ночи';
    ELSEIF now_time between 06 and 11 THEN
        return 'Доброе утро';
    ELSEIF now_time between 12 and 17 THEN
        return 'Добрый день';
    ELSE
        return 'Ololo';
    END IF;
END;

select hello();

-- Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP FUNCTION IF EXISTS fib;
CREATE function fib(n INT)
    RETURNS INT DETERMINISTIC
BEGIN
  DECLARE i int default 0;
  DECLARE fib1 INT DEFAULT 1;
  DECLARE fib2 INT DEFAULT 1;
  declare  fib_sum INT default 0;
  WHILE i < n - 2 DO
    SET fib_sum = fib1 + fib2;
    set fib1 = fib2;
    set fib2 = fib_sum;
    set i = i + 1;

      end while;
	SET i = i - 1;
  return fib2;
END;

SELECT fib(10);

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение
-- NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

-- триггер на UPDATE
drop trigger if exists check_update;

create trigger check_update before update on my_shop.products for each row
    begin
        if (NEW.name is NULL and NEW.description is NULL)
            then set NEW.name=OLD.name, NEW.description=old.description;
        end if;
    end;

update my_shop.products set name=NULL where id=3;

select * from my_shop.products;

-- триггер на SELECT
insert into my_shop.products (name, description, price, catalog_id) VALUES (null, null, 600, 2);


drop trigger if exists check_insert;
create trigger check_insert before insert on my_shop.products for each row
    begin
        if (NEW.name is NULL and NEW.description is NULL)
            then signal sqlstate '45000' set message_text = 'Name and description fields cann\'t be NULL!' ;
        end if;
    end;
