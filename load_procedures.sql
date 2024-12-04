DROP PROCEDURE IF EXISTS insert_into_user;
@delimiter %%%
CREATE PROCEDURE insert_into_user(IN in_user_id VARCHAR(9), IN in_handle VARCHAR(30), 
IN in_first_name VARCHAR(20), IN in_last_name varchar(20), IN in_email VARCHAR(40), 
IN in_birth_date DATE, IN in_password VARCHAR(15), IN in_profile_photo VARCHAR(50), 
IN in_profile_bio VARCHAR(50), IN in_join_date DATE)
	BEGIN
		INSERT INTO user (user_id, handle, first_name, last_name, email, birth_date, password,
	profile_photo, profile_bio, join_date) VALUES (in_user_id, in_handle, in_first_name, in_last_name, 
    in_email, in_birth_date, in_password, in_profile_photo, in_profile_bio, in_join_date);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS delete_from_user;
@delimiter %%%
CREATE PROCEDURE delete_from_user(IN in_user_id VARCHAR(9))
	BEGIN
		DELETE FROM user WHERE user.user_id = in_user_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS insert_into_follows;
@delimiter %%%
CREATE PROCEDURE insert_into_follows(IN in_user_id VARCHAR(9), IN in_user_followed_id VARCHAR(9))
	BEGIN
		INSERT INTO follows (user_id, user_followed_id) VALUES (in_user_id, in_user_followed_id);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS delete_from_follows;
@delimiter %%%
CREATE PROCEDURE delete_from_follows(IN in_user_id VARCHAR(9), IN in_user_followed_id VARCHAR(9))
	BEGIN
		DELETE FROM follows WHERE follows.user_id = in_user_id AND 
        follows.user_followed_id = in_user_followed_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS insert_into_post;
@delimiter %%%
CREATE PROCEDURE insert_into_post(IN in_post_id VARCHAR(13), IN in_user_id VARCHAR(9), 
IN in_text VARCHAR(140), IN in_image VARCHAR(15), IN in_timestamp DATETIME)
	BEGIN
		INSERT INTO post (post_id, user_id, text, image, timestamp) VALUES 
        (in_post_id, in_user_id, in_text, in_image, in_timestamp);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS delete_from_post;
@delimiter %%%
CREATE PROCEDURE delete_from_post(IN in_post_id VARCHAR(13))
	BEGIN
		DELETE FROM post WHERE post.post_id = in_post_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS insert_into_comment;
@delimiter %%%
CREATE PROCEDURE insert_into_comment(IN in_comment_id VARCHAR(17), 
IN in_user_id VARCHAR(9), IN in_post_id VARCHAR(13), IN in_ref_comment_id VARCHAR(17),
IN in_text VARCHAR(140), IN in_timestamp DATETIME)
	BEGIN
		INSERT INTO comment (comment_id, user_id, post_id, ref_comment_id, text, timestamp) 
        VALUES (in_comment_id, in_user_id, in_post_id, in_ref_comment_id, in_text, in_timestamp);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS delete_from_comment;
@delimiter %%%
CREATE PROCEDURE delete_from_comment(IN in_comment_id VARCHAR(17))
	BEGIN
		DELETE FROM comment WHERE comment.comment_id = in_comment_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_like_post;
@delimiter %%%
CREATE PROCEDURE user_like_post(IN target_user_id VARCHAR(9), 
IN target_post_id VARCHAR(13), IN in_timestamp DATETIME)
	BEGIN
		IF (target_user_id, target_post_id) NOT IN (SELECT user_id, post_id FROM like_post)
        THEN INSERT INTO like_post (user_id, post_id, timestamp) VALUES 
        (target_user_id, target_post_id, in_timestamp);
        END IF;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_like_comment;
@delimiter %%%
CREATE PROCEDURE user_like_comment(IN target_user_id VARCHAR(9), 
IN target_comment_id VARCHAR(17), IN in_timestamp DATETIME)
	BEGIN
		IF (target_user_id, target_comment_id) NOT IN (SELECT user_id, comment_id FROM like_comment)
        THEN INSERT INTO like_comment (user_id, comment_id, timestamp) VALUES 
        (target_user_id, target_comment_id, in_timestamp);
        END IF;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_unlike_post;
@delimiter %%%
CREATE PROCEDURE user_unlike_post(IN target_user_id VARCHAR(9), 
IN target_post_id VARCHAR(13))
	BEGIN
		DELETE FROM like_post WHERE like_post.user_id = target_user_id AND 
        like_post.post_id = target_post_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_unlike_comment;
@delimiter %%%
CREATE PROCEDURE user_unlike_comment(IN target_user_id VARCHAR(9), 
IN target_comment_id VARCHAR(17))
	BEGIN
		DELETE FROM like_comment WHERE like_comment.user_id = like_comment_target_user_id 
        AND like_comment.comment_id = target_comment_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_share_post;
@delimiter %%%
CREATE PROCEDURE user_share_post(IN in_user_id VARCHAR(9), 
IN in_post_id VARCHAR(13), IN in_timestamp DATETIME)
	BEGIN
		INSERT INTO share_post(user_id, post_id, timestamp) 
        VALUES (in_user_id, in_post_id, in_timestamp);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_share_comment;
@delimiter %%%
CREATE PROCEDURE user_share_comment(IN in_user_id VARCHAR(9), 
IN in_comment_id VARCHAR(17), IN in_timestamp DATETIME)
	BEGIN
		INSERT INTO share_comment(user_id, comment_id, timestamp) 
        VALUES (in_user_id, in_comment_id, in_timestamp);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_unshare_post;
@delimiter %%%
CREATE PROCEDURE user_unshare_post(IN in_user_id VARCHAR(9), IN in_post_id VARCHAR(13))
	BEGIN
		DELETE FROM share_post WHERE share_post.user_id = in_user_id AND
        share_post.post_id = in_post_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS user_unshare_comment;
@delimiter %%%
CREATE PROCEDURE user_unshare_comment(IN in_user_id VARCHAR(9), 
IN in_comment_id VARCHAR(17))
	BEGIN
		DELETE FROM share_comment WHERE share_comment.user_id = in_user_id AND 
        share_comment.commend_id = in_comment_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS get_num_posts_comments_by_target_user;
@delimiter %%%
CREATE PROCEDURE get_num_posts_comments_by_target_user(IN target_user_id VARCHAR(9), 
OUT num_target_posts INT, OUT num_target_comments INT)
	BEGIN
		SELECT COUNT(*) FROM post WHERE user_id = target_user_id INTO num_target_posts;
        SELECT COUNT(*) FROM comment WHERE user_id = target_user_id INTO num_target_comments;
	END;
%%%
@delimiter ;


DROP PROCEDURE IF EXISTS get_nth_target_post_id_and_timestamp;
@delimiter %%%
CREATE PROCEDURE get_nth_target_post_id_and_timestamp(IN target_user_id VARCHAR(9), IN n INT, OUT nth_post_id VARCHAR(13), OUT nth_timestamp DATETIME)
	BEGIN
		DECLARE n_offset INT;
        SET n_offset = n - 1;
    	SELECT post_id, timestamp FROM post WHERE user_id = target_user_id 
        ORDER BY post_id LIMIT 1 OFFSET n_offset INTO nth_post_id, nth_timestamp;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS get_nth_target_comment_id_and_timestamp;
@delimiter %%%
CREATE PROCEDURE get_nth_target_comment_id_and_timestamp(IN target_user_id VARCHAR(9), IN n INT, OUT nth_comment_id VARCHAR(17), OUT nth_timestamp DATETIME)
	BEGIN
		DECLARE n_offset INT;
        SET n_offset = n - 1;
    	SELECT comment_id, timestamp FROM comment WHERE user_id = target_user_id 
        ORDER BY comment_id LIMIT 1 OFFSET n_offset INTO nth_comment_id, nth_timestamp;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_user_most_following;
@delimiter %%%
CREATE PROCEDURE display_user_most_following()
	BEGIN
		SELECT * FROM user_view
        WHERE following_count = (SELECT MAX(following_count) FROM user_view);
    END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_user_most_followed;
@delimiter %%%
CREATE PROCEDURE display_user_most_followed()
	BEGIN
		SELECT * FROM user_view
        WHERE follower_count = (SELECT MAX(follower_count) FROM user_view);
    END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS find_user_last_name;
@delimiter %%%
CREATE PROCEDURE find_user_last_name(IN target_last_name VARCHAR(20))
	BEGIN
		SELECT * FROM user_view
        WHERE last_name = target_last_name;
    END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS find_user_handle;
@delimiter %%%
CREATE PROCEDURE find_user_handle(IN target_handle VARCHAR(30))
	BEGIN
		SELECT * FROM user_view
        WHERE handle = target_handle;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS most_liked_post;
@delimiter %%%
CREATE PROCEDURE most_liked_post()
	BEGIN
		SELECT * FROM post
        WHERE like_count = (SELECT MAX(like_count) FROM post);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS most_liked_comment;
@delimiter %%%
CREATE PROCEDURE most_liked_comment()
	BEGIN
		SELECT * FROM comment
        WHERE like_count = (SELECT MAX(like_count) FROM comment);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS most_shared_post;
@delimiter %%%
CREATE PROCEDURE most_shared_post()
	BEGIN
		SELECT * FROM post
        WHERE shared_count = (SELECT MAX(shared_count) FROM post);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS most_commented_post;
@delimiter %%%
CREATE PROCEDURE most_commented_post()
	BEGIN
		SELECT * FROM post
        WHERE comment_count = (SELECT MAX(comment_count) FROM post);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS most_liked_comment_for_post;
@delimiter %%%
CREATE PROCEDURE most_liked_comment_for_post(target_post_id VARCHAR(13))
	BEGIN
		SELECT * FROM comment
        WHERE comment.post_id = target_post_id
        AND comment.like_count = (SELECT MAX(comment.like_count) FROM comment
			WHERE comment.post_id = target_post_id);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS find_first_post;
@delimiter %%%
CREATE PROCEDURE find_first_post()
	BEGIN
		SELECT * FROM post
        WHERE post.timestamp = (SELECT MIN(timestamp) FROM post);
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS find_post_by_id;
@delimiter %%%
CREATE PROCEDURE find_post_by_id(IN target_post_id VARCHAR(13))
	BEGIN
		SELECT * FROM post
        WHERE post_id = target_post_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS find_comment_by_id;
@delimiter %%%
CREATE PROCEDURE find_comment_by_id(IN target_comment_id VARCHAR(17))
	BEGIN
		SELECT * FROM comment
        WHERE comment_id = target_comment_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_followers_by_cutoff;
@delimiter %%%
CREATE PROCEDURE display_followers_by_cutoff(IN target_user_id VARCHAR(9), IN cutoff INT)
	BEGIN
		SELECT B.handle, B.first_name, B.last_name, B.follower_count, B.following_count
        FROM user A, user B, follows
        WHERE follows.user_followed_id = A.user_id
        AND A.user_id = target_user_id
        AND B.user_id = follows.user_id
        AND B.follower_count >= cutoff;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_followers_you_follow;
@delimiter %%%
CREATE PROCEDURE display_followers_you_follow(IN target_user_id_a VARCHAR(9), IN target_user_id_b VARCHAR(9))
	BEGIN
		SELECT A.*
        FROM user_view A, follows
        WHERE follows.user_id = target_user_id_a
        AND follows.user_followed_id = A.user_id
        INTERSECT
        SELECT B.*
        FROM user_view B, follows
        WHERE follows.user_followed_id = target_user_id_b
        AND follows.user_id = B.user_id;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_user_liked_posts;
@delimiter %%%
CREATE PROCEDURE display_user_liked_posts(IN target_user_id VARCHAR(9))
	BEGIN
		SELECT DISTINCT post.*, like_post.timestamp AS liked_time FROM post, like_post
        WHERE like_post.user_id = target_user_id
        AND like_post.post_id = post.post_id
        ORDER BY like_post.timestamp DESC;
    END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_sharers_of_post;
@delimiter %%%
CREATE PROCEDURE display_sharers_of_post(IN target_post_id VARCHAR(13))
	BEGIN
		SELECT DISTINCT user_view.*, share_post.timestamp AS shared_time FROM user_view, share_post
        WHERE share_post.post_id = target_post_id
        AND user_view.user_id = share_post.user_id
        ORDER BY shared_time DESC;
    END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_likers_of_post_by_followers;
@delimiter %%%
CREATE PROCEDURE display_likers_of_post_by_followers(IN target_post_id VARCHAR(13))
	BEGIN
		SELECT DISTINCT user_view.* FROM user_view, like_post
        WHERE like_post.post_id = target_post_id
        AND user_view.user_id = like_post.user_id
        ORDER BY user_view.follower_count DESC;
    END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_users_posts;
@delimiter %%%
CREATE PROCEDURE display_users_posts(IN target_user_id VARCHAR(9))
	BEGIN
		SELECT post.* FROM post
        WHERE post.user_id = target_user_id
        ORDER BY post.timestamp DESC;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_users_comments;
@delimiter %%%
CREATE PROCEDURE display_users_comments(IN target_user_id VARCHAR(9))
	BEGIN
		SELECT comment.* FROM comment
        WHERE comment.user_id = target_user_id
        ORDER BY comment.timestamp DESC;
	END;
%%%
@delimiter ;

DROP PROCEDURE IF EXISTS display_comments_of_post;
@delimiter %%%
CREATE PROCEDURE display_comments_of_post(IN target_post_id VARCHAR(13))
	BEGIN
		SELECT comment.* FROM comment
        WHERE comment.post_id = target_post_id
        ORDER BY comment.like_count DESC, comment.shared_count DESC;
    END;
%%%
@delimiter ;







