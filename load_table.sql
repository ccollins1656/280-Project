DROP DATABASE IF EXISTS social;
CREATE DATABASE social;
USE social;

DROP TABLE IF EXISTS user;
CREATE TABLE user(
	user_id VARCHAR(9) NOT NULL,
	handle VARCHAR(30) NOT NULL,
	first_name VARCHAR(20) DEFAULT NULL,
	last_name VARCHAR(20) DEFAULT NULL,
	email VARCHAR(40) NOT NULL,
	birth_date DATE,
	password VARCHAR(15) NOT NULL,
	profile_photo VARCHAR(50) DEFAULT NULL,
	profile_bio VARCHAR(50) DEFAULT NULL,
	join_date DATE,
	following_count INTEGER DEFAULT 0,
	follower_count INTEGER DEFAULT 0,
	PRIMARY KEY(user_id),
	UNIQUE(email),
	UNIQUE(handle)
);

DROP TABLE IF EXISTS post;
CREATE TABLE post(
	post_id VARCHAR(13),
	user_id VARCHAR(9),
	text VARCHAR(140),
	image VARCHAR(15),
	timestamp DATETIME,
	like_count INTEGER DEFAULT 0,
	shared_count INTEGER DEFAULT 0,
	comment_count INTEGER DEFAULT 0,
	PRIMARY KEY(post_id),
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE SET NULL
);

DROP TABLE IF EXISTS comment;
CREATE TABLE comment(
	comment_id VARCHAR(17) NOT NULL,
	user_id VARCHAR(9),
	post_id VARCHAR(13),
	ref_comment_id VARCHAR(17),
	text VARCHAR(140),
	timestamp DATETIME,
	like_count INTEGER DEFAULT 0,
	shared_count INTEGER DEFAULT 0,
	PRIMARY KEY(comment_id),
	FOREIGN KEY(post_id) REFERENCES post(post_id) ON DELETE CASCADE,
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE SET NULL,
	FOREIGN KEY(ref_comment_id) REFERENCES comment(comment_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS follows;
CREATE TABLE follows(
	user_id VARCHAR(9) NOT NULL,
	user_followed_id VARCHAR(9) NOT NULL,
	PRIMARY KEY(user_id, user_followed_id),
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	FOREIGN KEY(user_followed_id) REFERENCES user(user_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS like_post;
CREATE TABLE like_post(
	user_id VARCHAR(9) NOT NULL,
	post_id VARCHAR(13) NOT NULL,
    timestamp DATETIME,
	PRIMARY KEY(user_id, post_id),
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	FOREIGN KEY(post_id) REFERENCES post(post_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS like_comment;
CREATE TABLE like_comment(
	user_id VARCHAR(9) NOT NULL,
	comment_id VARCHAR(17) NOT NULL,
    timestamp DATETIME,
	PRIMARY KEY(user_id, comment_id),
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	FOREIGN KEY(comment_id) REFERENCES comment(comment_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS share_post;
CREATE TABLE share_post(
	user_id VARCHAR(9) NOT NULL,
	post_id VARCHAR(13) NOT NULL,
    timestamp DATETIME,
	PRIMARY KEY(user_id, post_id),
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	FOREIGN KEY(post_id) REFERENCES post(post_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS share_comment;
CREATE TABLE share_comment(
	user_id VARCHAR(9) NOT NULL,
	comment_id VARCHAR(17) NOT NULL,
    timestamp DATETIME,
	PRIMARY KEY(user_id, comment_id),
	FOREIGN KEY(user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	FOREIGN KEY(comment_id) REFERENCES comment(comment_id) ON DELETE CASCADE
);