
SELECT * FROM user;
SELECT * FROM post ORDER BY user_id;
SELECT * FROM comment ORDER BY user_id;
SELECT * FROM share_post ORDER BY user_id;



-- Most Following
CALL display_user_most_following();

-- Most Followed
CALL display_user_most_followed();

-- Find user by last name
CALL find_user_last_name("Byers");

-- Find user by handle
CALL find_user_handle("@Harrison4");

-- Find most liked post
CALL most_liked_post();

CALL user_like_post('U00000001', 'P000000000001', '2024-02-13 05:37:17');

-- Find most liked comment
CALL most_liked_comment();

-- Find most shared post
CALL most_shared_post();

-- Find most commented post
CALL most_commented_post();

-- Find most liked comment under post
CALL most_liked_comment_for_post("P000000000031");

-- Find first post
CALL find_first_post();

-- Find comment by id
CALL find_comment_by_id('C0000000000000017');

-- Display followers with min following count
CALL display_followers_by_cutoff('U00000006', 100);

-- Display users liked posts
CALL display_user_liked_posts('U00000008');

-- Display sharers of post
CALL display_sharers_of_post('P000000000017');

-- Display likers of comment
CALL display_likers_of_post_by_followers('P000000000001');

-- Display users posts
CALL display_users_posts('U00000008');

-- Display users comments
CALL display_users_comments('U00000670');

-- Display comments under post
CALL display_comments_of_post('P000000000021');

CALL delete_from_comment('C0000000000000023');


-- Display users posts and comments, then delete user and demonstrate their posts exist
CALL display_users_posts('U00000033');
-- posts and comments ordered timestamp
CALL display_users_comments('U00000033');

CALL delete_from_user('U00000033');

CALL find_post_by_id('P000000000005');

CALL find_comment_by_id('C0000000000000008');

-- Delete post and show it cannot be shown, nor its comments
CALL display_comments_of_post('P000000000005');
-- ordered by by like count, share count, aka popularity
CALL delete_from_post('P000000000005');

CALL find_post_by_id('P000000000005');

CALL find_comment_by_id('C0000000000000005');

-- Display followers of user whom you also follow
CALL insert_into_follows('U00000001', 'U00000002');

CALL insert_into_follows('U00000002', 'U00000003');

CALL display_followers_you_follow('U00000001', 'U00000003');




