DROP DATABASE IF EXISTS vk;

CREATE DATABASE IF NOT EXISTS vk;

USE vk;

-- network users
CREATE TABLE users(
	id BIGINT UNSIGNED auto_increment PRIMARY KEY,
	firstname VARCHAR(150) NOT NULL,
	lastname VARCHAR(150) NOT NULL,
	email VARCHAR (150) UNIQUE NOT NULL,
    phone CHAR(11) UNIQUE NOT NULL,
    password_hash CHAR(65) DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX (lastname)
);

-- users details
CREATE TABLE profiles(
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender ENUM('f', 'm', 'x') NOT NULL,
	birthday DATE NOT NULL,
	photo_id BIGINT UNSIGNED,
    city VARCHAR(130),
    country VARCHAR(130),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- messages between users
CREATE TABLE messages(
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    txt TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_delivered BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- requests to add a friend
CREATE TABLE friend_requests(
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    accepted BOOL DEFAULT FALSE,
    PRIMARY KEY (from_user_id, to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- communities
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255),
    admin_id BIGINT UNSIGNED NOT NULL,
    KEY (name), -- equivalent of INDEX
    FOREIGN KEY (admin_id) REFERENCES users(id)
);

-- belonging to the community
CREATE TABLE communities_users(
	community_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (community_id, user_id),
    FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- file types
CREATE TABLE media_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- uploaded files
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_types_id INT UNSIGNED NOT NULL,
    file_name VARCHAR(255),
    file_size BIGINT UNSIGNED,
    created_at DATETIME DEFAULT NOW(), -- equivalent of CURRENT_TIMESTAMP
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(media_types_id) REFERENCES media_types(id)
);

-- posts
CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
    creator_id BIGINT UNSIGNED NOT NULL,
    txt TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(creator_id) REFERENCES users(id),
    INDEX(creator_id)
);

-- views (amount of post views)
CREATE TABLE views(
	post_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    amount BIGINT UNSIGNED DEFAULT 0,
    FOREIGN KEY(post_id) REFERENCES posts(id),
    INDEX(amount)
);

-- files which referenced to posts (many to many)
CREATE TABLE post_files(
	media_id BIGINT UNSIGNED NOT NULL,
    post_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (media_id, post_id),
    FOREIGN KEY(media_id) REFERENCES media(id),
    FOREIGN KEY(post_id) REFERENCES posts(id)
);

-- comments
CREATE TABLE comments(
	id SERIAL PRIMARY KEY,
    post_id BIGINT UNSIGNED NOT NULL,
    creator_id BIGINT UNSIGNED NOT NULL,
    txt TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(post_id) REFERENCES posts(id),
    FOREIGN KEY(creator_id) REFERENCES users(id),
    INDEX(post_id)
);
