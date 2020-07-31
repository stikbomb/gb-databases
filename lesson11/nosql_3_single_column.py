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
    create_db(db_client, 'shop_products')
    my_db = db_client['shop_products']
    products = [{'name': 'Intel Core i3-8100',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
                 'price': 7890.00,
                 'catalog_id': 1
                 },
                {'name': 'Intel Core i5-7400',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
                 'price': 12700.00,
                 'catalog_id': 1
                 },
                {'name': 'AMD FX-8320E',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.',
                 'price': 4780.00,
                 'catalog_id': 1
                 },
                {'name': 'AMD FX-8320',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.',
                 'price': 7120.00,
                 'catalog_id': 1
                 },
                {'name': 'ASUS ROG MAXIMUS X HERO',
                 'description': 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
                 'price': 19310.00,
                 'catalog_id': 2
                 },
                {'name': 'Gigabyte H310M S2H',
                 'description': 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX',
                 'price': 4790.00,
                 'catalog_id': 2
                 },
                {'name': 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX',
                 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
                 'price': 5060.00,
                 'catalog_id': 2
                 }
                ]

    products_col = my_db['products']
    inserted_ids = products_col.insert_many(products)
    print(inserted_ids)

    for prod in products_col.find():
        print(prod)