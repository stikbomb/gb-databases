-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу
-- logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

use my_shop;


drop table if exists my_shop.log_archive;

CREATE TABLE my_shop.`log_archive` (
   `date` date NOT NULL,
   `time` time NOT NULL,
   `table_name` varchar(25) NOT NULL,
   `item_id` int not null,
   `name` varchar(100) not null
 ) ENGINE = ARCHIVE;

drop trigger if exists insert_user;
drop trigger if exists insert_catalog;
drop trigger if exists insert_product;


CREATE TRIGGER insert_user AFTER insert oN `my_shop`.`users`
 FOR EACH ROW BEGIN
   INSERT INTO my_shop.log_archive (date, time, table_name, item_id, name) VALUES
   (date(now()), time(now()), 'users', new.id, new.name);
END;

CREATE TRIGGER insert_catalog AFTER insert oN `my_shop`.`catalogs`
 FOR EACH ROW BEGIN
   INSERT INTO my_shop.log_archive (date, time, table_name, item_id, name) VALUES
   (date(now()), time(now()), 'catalogs', new.id, new.name);
END;

CREATE TRIGGER insert_product AFTER insert oN `my_shop`.`products`
 FOR EACH ROW BEGIN
   INSERT INTO my_shop.log_archive (date, time, table_name, item_id, name) VALUES
   (date(now()), time(now()), 'products', new.id, new.name);
END;

SELECT * from my_shop.log_archive;

insert into my_shop.users (name) value ('Hovard');

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1);

INSERT INTO catalogs VALUES
  (NULL, 'МегаМегаПроцессоры');

SELECT * from my_shop.log_archive;

select * from users;

-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
-- Оптимизировано только через транзакцию! (доделать)

drop table if exists my_shop.spam;

create table my_shop.spam (
    item varchar(15)
);

drop procedure if exists fill_million_rows;

CREATE PROCEDURE fill_million_rows()
BEGIN
    DECLARE i int DEFAULT 0;
    WHILE i <= 1000000 DO
        INSERT INTO my_shop.spam (item) VALUES (concat(item, i));
        SET i = i + 1;
    END WHILE;
END;

start transaction;
call fill_million_rows;
commit;

select count(*) from my_shop.spam;