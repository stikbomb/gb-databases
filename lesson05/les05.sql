-- База данных для социальной сети

DROP DATABASE IF EXISTS lesson05;
CREATE DATABASE lesson05;
USE lesson05;

-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    name       varchar(50),
    created_at DATETIME NULL,
    updated_at DATETIME NULL
);

INSERT into users (name, created_at, updated_at)
VALUES ('Anna', '2019-12-25', '2020-01-28');
INSERT into users (name, created_at)
VALUES ('Bill', '2018-11-05');
INSERT into users (name)
VALUES ('Charlie');
INSERT into users (name, updated_at)
VALUES ('David', '2018-04-23');
INSERT into users (name, created_at, updated_at)
VALUES ('Frank', '2019-10-23', '2020-02-23');

UPDATE users
set created_at = NOW()
where created_at is NULL;
UPDATE users
set updated_at = NOW()
where updated_at is NULL;

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR
-- и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME,
-- сохранив введеные ранее значения.

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    name       varchar(50),
    created_at VARCHAR(20),
    updated_at VARCHAR(20)
);

INSERT into users (name, created_at, updated_at)
VALUES ('Anna', '20.10.2012 8:10', '20.10.2013 12:10');
INSERT into users (name, created_at, updated_at)
VALUES ('Bill', '31.12.2012 9:10', '28.02.2014 11:10');
INSERT into users (name, created_at, updated_at)
VALUES ('Charlie', '16.01.2013 10:10', '20.03.2014 10:10');
INSERT into users (name, created_at, updated_at)
VALUES ('David', '05.05.2013 11:10', '25.06.2014 9:10');
INSERT into users (name, created_at, updated_at)
VALUES ('Frank', '11.09.2014 12:10', '05.11.2016 8:10');



ALTER TABLE users
    ADD new_created_at DATETIME;
ALTER TABLE users
    ADD new_updated_at DATETIME;

UPDATE users
SET new_created_at = addtime(STR_TO_DATE(SUBSTRING_INDEX(created_at, ' ', 1), '%d.%m.%Y'),
                             SUBSTRING_INDEX(created_at, ' ', -1));
UPDATE users
SET new_updated_at = addtime(STR_TO_DATE(SUBSTRING_INDEX(updated_at, ' ', 1), '%d.%m.%Y'),
                             SUBSTRING_INDEX(updated_at, ' ', -1));

ALTER TABLE users
    DROP COLUMN created_at;
ALTER TABLE users
    DROP COLUMN updated_at;

ALTER TABLE users RENAME COLUMN new_updated_at to updated_at;
ALTER TABLE users RENAME COLUMN new_created_at to created_at;

SELECT month(created_at)
from users;

-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
-- если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
-- чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце,
-- после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products
(
    title varchar(100),
    value int(10)
);

INSERT storehouses_products (title, value)
values ('Кофеварка', 0);
INSERT storehouses_products (title, value)
values ('Чайник', 1);
INSERT storehouses_products (title, value)
values ('Микроволновка', 4);
INSERT storehouses_products (title, value)
values ('Блендер', 7);
INSERT storehouses_products (title, value)
values ('Скороварка', 4);
INSERT storehouses_products (title, value)
values ('Мультиварка', 0);
INSERT storehouses_products (title, value)
values ('Блендер', 0);
INSERT storehouses_products (title, value)
values ('Гриль', 1);

SELECT *
FROM storehouses_products
ORDER BY value = 0, value;


-- Подсчитайте средний возраст пользователей в таблице users
-- Подсчитайте количество дней рождения, которые приходятся на каждую из дней недели. Следует учесть,
-- что необходимы дни недели текущего года, а не года рождения.

DROP TABLE IF EXISTS users_2;
CREATE TABLE users_2
(
    id       SERIAL PRIMARY KEY,
    name     varchar(50),
    birthday date
);

INSERT into users_2 (name, birthday)
VALUES ('Anna', '1985-12-31');
INSERT into users_2 (name, birthday)
VALUES ('Bill', '1987-11-14');
INSERT into users_2 (name, birthday)
VALUES ('Charlie', '2000-10-15');
INSERT into users_2 (name, birthday)
VALUES ('David', '1999-06-14');
INSERT into users_2 (name, birthday)
VALUES ('Frank', '1950-12-20');
INSERT into users_2 (name, birthday)
VALUES ('Frank', '2019-07-10');


select DAYOFWEEK(
               concat(YEAR(now()), '-', month(birthday), '-', day(birthday))
           )
from users_2;

select DAYOFWEEK(
               concat(YEAR(now()), '-', month(birthday), '-', day(birthday))
           )    as 'day of week',
       count(*) as count
from users_2
group by DAYOFWEEK(
                 concat(YEAR(now()), '-', month(birthday), '-', day(birthday))
             );

SELECT round(AVG(YEAR(CURDATE()) -
           YEAR(birthday) -
           IF(STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(birthday), '-', DAY(birthday)), '%Y-%c-%e') > CURDATE(), 1,
              0)
           ))
FROM users_2;

