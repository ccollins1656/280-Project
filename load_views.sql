
CREATE INDEX user_id_index ON user(user_id) USING BTREE;

CREATE INDEX post_id_index ON post(post_id) USING BTREE;

CREATE INDEX post_like_index ON post(like_count) USING BTREE;

-- 1.
CREATE VIEW user_view(user_id,
	handle,
	first_name,
	last_name,
	profile_photo,
	profile_bio,
	join_date,
	following_count,
	follower_count)
	AS SELECT user.user_id, user.handle, user.first_name, user.last_name, user.profile_photo, user.profile_bio,
	user.join_date, user.following_count, user.follower_count
    FROM user;
    

    