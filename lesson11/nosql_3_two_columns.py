import pymongo


def create_db(db_client, db_name):
    db_list = db_client.list_database_names()
    print(db_list)

    if db_name in db_list:
        print("The database exists.")
    else:
        my_db = db_client["shop_products"]
        print("Database was created.")


if __name__ == '__main__':
    db_client = pymongo.MongoClient("mongodb://localhost:27017/")
    db_name = 'shop_products_with_cats'
    create_db(db_client, db_name)
    my_db = db_client[db_name]

    categories = [{'name': 'Процессоры'},
                  {'name': 'Материнские платы'}]

    categories_col = my_db['categories']
    categories_col.drop()
    proc_cat_id, motherboard_cat_id = categories_col.insert_many(categories).inserted_ids

    products = [{'name': 'Intel Core i3-8100',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
                 'price': 7890.00,
                 'catalog_id': proc_cat_id
                 },
                {'name': 'Intel Core i5-7400',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
                 'price': 12700.00,
                 'catalog_id': proc_cat_id
                 },
                {'name': 'AMD FX-8320E',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.',
                 'price': 4780.00,
                 'catalog_id': proc_cat_id
                 },
                {'name': 'AMD FX-8320',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.',
                 'price': 7120.00,
                 'catalog_id': proc_cat_id
                 },
                {'name': 'ASUS ROG MAXIMUS X HERO',
                 'description': 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
                 'price': 19310.00,
                 'catalog_id': motherboard_cat_id
                 },
                {'name': 'Gigabyte H310M S2H',
                 'description': 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX',
                 'price': 4790.00,
                 'catalog_id': motherboard_cat_id
                 },
                {'name': 'MSI B250M GAMING PRO',
                 'description': 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX.',
                 'price': 5060.00,
                 'catalog_id': motherboard_cat_id
                 }
                ]

    products_col = my_db['products']
    products_col.drop()
    inserted_ids = products_col.insert_many(products)

    print('Добавленные категории')
    for cat in categories_col.find():
        print(cat)
    print()

    print('Добавленные товары')
    for prod in products_col.find():
        print(prod)
    print()

    query = {'catalog_id': motherboard_cat_id}

    print('Выборка материнских плат')
    for motherboard in products_col.find(query):
        print(motherboard)
    print()

    response = list(products_col.aggregate([
        {
            '$lookup':
                {
                    'from': "categories",
                    'localField': "catalog_id",
                    'foreignField': "_id",
                    'as': "catalog_name"
                }
        }
    ]))

    print('Объединение таблиц')
    for item in response:
        print(item)