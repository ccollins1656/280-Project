--
-- Input Validation
--
/*
DROP TRIGGER IF EXISTS validate_user_id;
@delimiter %%%
CREATE TRIGGER validate_user_id
	AFTER INSERT ON user
    FOR EACH ROW BEGIN
		IF NEW.user_id NOT LIKE 'U________'
        THEN DELETE FROM user
        WHERE user_id = NEW.user_id;
        END IF;
    END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS validate_post_id;
@delimiter %%%
CREATE TRIGGER validate_post_id
	AFTER INSERT ON post
    FOR EACH ROW BEGIN
		IF NEW.post_id NOT LIKE 'P____________'
        THEN DELETE FROM user
        WHERE post_id = NEW.post_id;
        END IF;
    END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS validate_comment_id;
@delimiter %%%
CREATE TRIGGER validate_comment_id
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		IF NEW.comment_id NOT LIKE 'C____________'
        THEN DELETE FROM user
        WHERE comment_id = NEW.comment_id;
        END IF;
    END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS validate_email;
@delimiter %%%
CREATE TRIGGER validate_email
	AFTER INSERT ON user
    FOR EACH ROW BEGIN
		IF NEW.email NOT LIKE ('_%@_%.com' OR '_%@_%.edu')
        THEN DELETE FROM user
        WHERE email = NEW.email;
        END IF;
    END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS reset_following_count;
@delimiter %%%
CREATE TRIGGER reset_following_count
	AFTER INSERT ON user
    FOR EACH ROW BEGIN
		IF NEW.following_count != 0
        THEN UPDATE user SET following_count = 0
        WHERE user.user_id = NEW.user_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS reset_follower_count;
@delimiter %%%
CREATE TRIGGER reset_follower_count
	AFTER INSERT ON user
    FOR EACH ROW BEGIN
		IF NEW.follower_count != 0
        THEN UPDATE user SET follower_count = 0
        WHERE user.user_id = NEW.user_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS post_like_count;
@delimiter %%%
CREATE TRIGGER post_like_count
	AFTER INSERT ON post
    FOR EACH ROW BEGIN
		IF NEW.like_count != 0
        THEN UPDATE post SET like_count = 0
        WHERE post.post_id = NEW.post_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS post_comment_count;
@delimiter %%%
CREATE TRIGGER post_comment_count
	AFTER INSERT ON post
    FOR EACH ROW BEGIN
		IF NEW.comment_count != 0
        THEN UPDATE post SET comment_count = 0
        WHERE post.post_id = NEW.post_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS post_shared_count;
@delimiter %%%
CREATE TRIGGER post_shared_count
	AFTER INSERT ON post
    FOR EACH ROW BEGIN
		IF NEW.shared_count != 0
        THEN UPDATE post SET shared_count = 0
        WHERE post.post_id = NEW.post_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS comment_like_count;
@delimiter %%%
CREATE TRIGGER comment_like_count
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		IF NEW.like_count != 0
        THEN UPDATE comment SET like_count = 0
        WHERE comment_id = NEW.comment_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS comment_comment_count;
@delimiter %%%
CREATE TRIGGER comment_comment_count
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		IF NEW.comment_count != 0
        THEN UPDATE comment SET comment_count = 0
        WHERE comment_id = NEW.comment_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS comment_shared_count;
@delimiter %%%
CREATE TRIGGER comment_shared_count
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		IF NEW.shared_count != 0
        THEN UPDATE comment SET shared_count = 0
        WHERE comment_id = NEW.comment_id;
        END IF;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS valid_existing_comment;
@delimiter %%%
CREATE TRIGGER valid_existing_comment
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		IF (NEW.ref_comment_id = NULL AND NEW.post_id = NULL)
        OR (NEW.ref_comment_id != NULL AND NEW.post_id != NULL)
        THEN DELETE FROM comment
        WHERE comment_id = NEW.comment_id;
		END IF;
	END;
%%%
@delimiter ;
*/
--
-- Increment/Decrement Derived Attributes
--
DROP TRIGGER IF EXISTS inc_follow_count;
@delimiter %%%
CREATE TRIGGER inc_follower_count
	AFTER INSERT ON follows
    FOR EACH ROW BEGIN
		UPDATE user SET following_count = following_count + 1
        WHERE user.user_id = NEW.user_id;
		UPDATE user SET follower_count = follower_count + 1
        WHERE user.user_id = NEW.user_followed_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS dec_follow_count;
@delimiter %%%
CREATE TRIGGER dec_follower_count
	AFTER DELETE ON follows
    FOR EACH ROW BEGIN
		UPDATE user SET following_count = following_count - 1
        WHERE user.user_id = OLD.user_id;
		UPDATE user SET follower_count = follower_count - 1
        WHERE user.user_id = OLD.user_followed_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS inc_post_like_count;
@delimiter %%%
CREATE TRIGGER inc_post_like_count
	AFTER INSERT ON like_post
    FOR EACH ROW BEGIN
		UPDATE post SET like_count = like_count + 1
        WHERE post.post_id = NEW.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS dec_post_like_count;
@delimiter %%%
CREATE TRIGGER dec_post_like_count
	AFTER DELETE ON like_post
    FOR EACH ROW BEGIN
		UPDATE post SET like_count = like_count - 1
        WHERE post.post_id = OLD.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS inc_post_comment_count;
@delimiter %%%
CREATE TRIGGER inc_post_comment_count
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		UPDATE post SET comment_count = comment_count + 1
        WHERE post.post_id = NEW.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS dec_post_comment_count;
@delimiter %%%
CREATE TRIGGER dec_post_comment_count
	AFTER DELETE ON comment
    FOR EACH ROW BEGIN
		UPDATE post SET comment_count = comment_count - 1
        WHERE post.post_id = OLD.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS inc_post_shared_count;
@delimiter %%%
CREATE TRIGGER inc_post_share_count
	AFTER INSERT ON share_post
    FOR EACH ROW BEGIN
		UPDATE post SET shared_count = shared_count + 1
        WHERE post.post_id = NEW.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS dec_post_shared_count;
@delimiter %%%
CREATE TRIGGER dec_post_shared_count
	AFTER DELETE ON share_post
    FOR EACH ROW BEGIN
		UPDATE post SET shared_count = shared_count - 1
        WHERE post.post_id = OLD.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS inc_comment_like_count;
@delimiter %%%
CREATE TRIGGER inc_comment_like_count
	AFTER INSERT ON like_comment
    FOR EACH ROW BEGIN
		UPDATE comment SET like_count = like_count + 1
        WHERE comment.comment_id = NEW.comment_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS dec_comment_like_count;
@delimiter %%%
CREATE TRIGGER dec_comment_like_count
	AFTER DELETE ON like_comment
    FOR EACH ROW BEGIN
		UPDATE comment SET like_count = like_count - 1
        WHERE comment.comment_id = OLD.comment_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS inc_comment_shared_count;
@delimiter %%%
CREATE TRIGGER inc_comment_shared_count
	AFTER INSERT ON share_comment
    FOR EACH ROW BEGIN
		UPDATE comment SET shared_count = shared_count + 1
        WHERE comment.comment_id = NEW.comment_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS dec_comment_shared_count;
@delimiter %%%
CREATE TRIGGER dec_comment_shared_count
	AFTER DELETE ON share_comment
    FOR EACH ROW BEGIN
		UPDATE comment SET shared_count = shared_count - 1
        WHERE comment.comment_id = OLD.comment_id;
	END;
%%%
@delimiter ;

/*
DROP TRIGGER IF EXISTS post_char_count;
@delimiter %%%
CREATE TRIGGER post_char_count
	AFTER INSERT ON post
    FOR EACH ROW BEGIN
		UPDATE post SET char_count = LENGTH(text)
        WHERE post.post_id = NEW.post_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS comment_char_count;
@delimiter %%%
CREATE TRIGGER comment_char_count
	AFTER INSERT ON comment
    FOR EACH ROW BEGIN
		UPDATE comment SET char_count = LENGTH(text)
        WHERE comment.comment_id = NEW.comment_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS share_post_char_count;
@delimiter %%%
CREATE TRIGGER share_post_char_count
	AFTER INSERT ON share_post
    FOR EACH ROW BEGIN
		UPDATE share_post SET char_count = LENGTH(text)
        WHERE share_post.post_id = NEW.post_id
        AND share_post.user_id = NEW.user_id;
	END;
%%%
@delimiter ;

DROP TRIGGER IF EXISTS share_comment_char_count;
@delimiter %%%
CREATE TRIGGER share_comment_char_count
	AFTER INSERT ON share_comment
    FOR EACH ROW BEGIN
		UPDATE share_comment SET char_count = LENGTH(text)
        WHERE share_comment.comment_id = NEW.comment_id
        AND share_comment.user_id = NEW.user_id;
	END;
%%%
@delimiter ;
*/