-- База данных для социальной сети

DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	login VARCHAR(50),
	email VARCHAR(120) UNIQUE,
    phone BIGINT,
   	INDEX users_phone_idx(phone)
);

-- аватарки пользователей будут хранится в отдельной таблице

DROP TABLE IF EXISTS avatars;
CREATE TABLE avatars(
    id SERIAL PRIMARY KEY,
    path varchar(255) NOT NULL,
    created_at DATETIME DEFAULT NOW()
);


-- в нашей соцсети можно иметь несколько профилей (аккаунтов)

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	id SERIAL PRIMARY key,
	user_id BIGINT UNSIGNED NOT NULL,
    gender CHAR(1),
    birthday DATE,
	avatar_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (avatar_id) REFERENCES avatars(id)
);

-- Сообщения

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_profile_id BIGINT UNSIGNED NOT NULL,
    to_profile_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME default NOW(),
    INDEX(from_profile_id),
  	INDEX(to_profile_id),
  	FOREIGN KEY (from_profile_id) REFERENCES profiles(id),
  	FOREIGN KEY (to_profile_id) REFERENCES profiles(id)
);

-- заявки в друзья
-- дружба может быть односторонней, подписываемся на человека

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_profile_id BIGINT UNSIGNED NOT NULL,
	target_profile_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested', 'approved', 'unfriended', 'declined'),
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME,
	PRIMARY KEY (initiator_profile_id, target_profile_id),
	INDEX(initiator_profile_id),
  	INDEX(target_profile_id),
  	FOREIGN KEY (initiator_profile_id) REFERENCES profiles(id),
  	FOREIGN KEY (target_profile_id) REFERENCES profiles(id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	INDEX(name)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	profile_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (profile_id, community_id), 
  	FOREIGN KEY (profile_id) REFERENCES profiles(id),
  	FOREIGN KEY (community_id) REFERENCES communities(id)
);


DROP TABLE IF EXISTS posts;
CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
	profile_id BIGINT UNSIGNED NOT NULL,
	body text,
	attachments JSON,
	metadata JSON,
	parent_post_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (profile_id) REFERENCES profiles(id),
	FOREIGN KEY (parent_post_id) REFERENCES posts(id)
);

DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
	id SERIAL PRIMARY KEY,
	profile_id BIGINT UNSIGNED NOT NULL,
	post_id BIGINT UNSIGNED NOT NULL,
	body text,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (profile_id) REFERENCES profiles(id),
	FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- рассматриваем вариант, в котором в базе данных хранятся лишь ссылки на путь к медиафайлам
-- сами файлы хранятся в отдельном хранилище

DROP TABLE IF EXISTS media_files;
CREATE TABLE media_files(
    id SERIAL PRIMARY KEY,
    profile_id BIGINT UNSIGNED NOT NULL,
    path varchar(255) NOT NULL,
    title varchar(100) NOT NULL,
    description TEXT,
    type ENUM('picture', 'audio', 'video'),
    index(title),
    FOREIGN KEY (profile_id) references profiles(id)
);

-- лайки к постам, медиа и профилям будут хранится в трёх разных таблицах

DROP TABLE IF EXISTS posts_likes;
CREATE TABLE posts_likes(
    profile_id BIGINT UNSIGNED NOT NULL,
    post_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (profile_id, post_id),
    FOREIGN KEY (profile_id) references profiles(id),
    FOREIGN KEY (post_id) references posts(id)
);

DROP TABLE IF EXISTS media_files_likes;
CREATE TABLE media_files_likes(
    profile_id BIGINT UNSIGNED NOT NULL,
    media_file_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (profile_id, media_file_id),
    FOREIGN KEY (profile_id) references profiles(id),
    FOREIGN KEY (media_file_id) references media_files(id)
);

DROP TABLE IF EXISTS profiles_likes;
CREATE TABLE profiles_likes(
    profile_id BIGINT UNSIGNED NOT NULL,
    target_profile_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (profile_id, target_profile_id),
    FOREIGN KEY (profile_id) references profiles(id),
    FOREIGN KEY (target_profile_id) references profiles(id)
);