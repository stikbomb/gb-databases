-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
use my_shop;
insert into my_shop.orders (id, user_id) values ('1', '1'), ('2', '1'), ('3', '3'), ('4', '5'), ('5', '5'), ('6', '6');

-- Способ 1
SELECT user_id from my_shop.orders group by user_id;

-- Способ 2
select id from my_shop.users where id in (select user_id from my_shop.orders);


-- Выведите список товаров products и разделов catalogs, который соответствует товару.
-- рузультирующая таблица вида |Товары категории 'Процессор'|Название категории 'Процессоры'|
-- искомый товар AMD FX-8320
select products.name, catalogs.name from (
    select * from products where catalog_id in (
        select catalog_id from my_shop.products where products.name = 'AMD FX-8320')) as products
    join my_shop.catalogs on catalog_id=catalogs.id;


-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

drop database if exists lesson07;
create database lesson07;
use lesson07;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
    id SERIAL PRIMARY KEY,
    `from` VARCHAR(100),
    `to` VARCHAR(100)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
    label VARCHAR(100),
    name VARCHAR(100)
);

insert into flights (id, `from`, `to`) values
    (1, 'moscow', 'omsk'), (2, 'novgorod', 'kazan'), (3, 'irkutsk', 'moscow'), (4, 'omsk', 'irkutsk'), (5, 'moscow', 'kazan');

insert into cities (label, name) VALUES
    ('moscow', 'Москва'), ('irkutsk', 'Иркутск'), ('novgorod', 'Новгород'), ('kazan', 'Казань'), ('omsk', 'Омск');

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
    id SERIAL PRIMARY KEY,
    `from` VARCHAR(100),
    `to` VARCHAR(100)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
    label VARCHAR(100),
    name VARCHAR(100)
);

select id, t.name as `from`, cities.name as 'to'
from ((SELECT * from flights join lesson07.cities on (flights.`from`=cities.label)) as t join lesson07.cities on t.`to`=cities.label)
order by id;
