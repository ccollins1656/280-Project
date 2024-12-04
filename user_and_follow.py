import mysql.connector
import random

# global counters for next ID numbers for both post and id, as well as image
post_num, comment_num, image_num = 1, 1, 1

num_users = 10000 # chosen number of users for the database

# load possibilities of first names + last names
first_names = []
with open('first-names.txt', 'r') as file:
    for line in file:
        line = line.strip()
        first_names.append(line)
file.close()

last_names = []
with open('last-names.txt', 'r') as file:
    for line in file:
        line = line.strip()
        last_names.append(line)
file.close()

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="social"
)

mycursor = mydb.cursor()

# Helper function to determine random umber in [lower, upper] range
def rng(lower, upper):
    return random.randint(lower, upper)

def create_text(text_length):
    text = ''
    for i in range(1, text_length + 1):
        ascii_char = rng(32, 127)
        if ascii_char == 127:
            break
        text += chr(ascii_char)

    return text

def next_day(timestamp):
    new_timestamp = None
    year, month, day = int(timestamp[:4]), int(timestamp[5:7]), int(timestamp[8:10])
    timestamp_remainder = timestamp[10:]

    if (day + 1) <= 28:
        new_timestamp = str(year) + '-' + str(month).rjust(2, '0') + \
            '-' + str(day + 1).rjust(2, '0') + timestamp_remainder
    elif (month + 1) <= 12:
        new_timestamp = str(year) + '-' + str(month + 1).rjust(2, '0') + \
            '-01' + timestamp_remainder
    else:
        new_timestamp = str(year + 1) + '-01-01' + timestamp_remainder

    return new_timestamp

def get_nth_post_id_and_timestamp(target_user_id, n):
    result = mycursor.callproc("get_nth_target_post_id_and_timestamp", \
                        (target_user_id, n, 0, ""))
    return result[2], next_day(result[3])

def get_nth_comment_id_and_timestamp(target_user_id, n):
    result = mycursor.callproc("get_nth_target_comment_id_and_timestamp", \
                               (target_user_id, n, 0, ""))
    return result[2], next_day(result[3])

def create_new_post(target_user_id):
    #curr_sql = "INSERT INTO post (post_id, user_id, text, image, timestamp) VALUES (%s, %s, %s, %s, %s)"
    global post_num
    curr_post_num = post_num
    post_id = "P" + str(curr_post_num).rjust(12, '0')
    post_num += 1
    text = create_text(140)
    global image_num
    image = "image" + str(image_num) + ".jpeg"
    image_num += 1
    timestamp = str(rng(2010, 2024)) + '-' + str(rng(1, 12)).rjust(2, '0') + '-' + str(rng(1, 27)).rjust(2, '0') \
        + " " + str(rng(0, 23)).rjust(2, '0') + ":" + str(rng(0, 59)).rjust(2, '0') + ":" + str(rng(0, 59)).rjust(2, '0')
    curr_val = (post_id, target_user_id, text, image, timestamp)
    mycursor.callproc("insert_into_post", curr_val)
    #mycursor.execute(curr_sql, curr_val)
    mydb.commit()

    return post_id, timestamp

# Helper function that determines which post/comment gets reply/share
def choose_receiver_of_comment_or_share(target_user_id, post_num, share=0):
    result = mycursor.callproc("get_num_posts_comments_by_target_user", \
                            (target_user_id, 0, 0))
    post_cnt, comment_cnt = result[1], result[2]

    random_num = rng(1, post_cnt + comment_cnt + 1)

    if random_num <= post_cnt:
        post_id, timestamp = get_nth_post_id_and_timestamp(target_user_id, random_num)
        ref_comment_id = None

    elif random_num <= comment_cnt:
        ref_comment_id, timestamp = get_nth_comment_id_and_timestamp(target_user_id, random_num - post_cnt)
        post_id = None

    else:
        post_id, timestamp = create_new_post(target_user_id)
        ref_comment_id = None

    random_num = random.random()
    threshold = 0.9 if share else 0.5
    if (random_num < threshold):
        if ref_comment_id == None:
            mycursor.callproc("user_like_post", (target_user_id, post_id, next_day(timestamp)))
        else:
            mycursor.callproc("user_like_comment", (target_user_id, ref_comment_id, next_day(timestamp)))
        mydb.commit()

    return post_id, ref_comment_id, timestamp

# Prepare synthetic insertions of user tuples

#sql = "INSERT INTO user (user_id, handle, first_name, last_name, email, birth_date, password, profile_photo, profile_bio, join_date) \
#    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

for i in range(1, num_users + 1):
    u_id = "U" + str(i).rjust(8, '0')
    first_name = first_names[rng(0, len(first_names) - 1)]
    last_name = last_names[rng(0, len(last_names) - 1)]
    handle = "@" + last_name + str(i)
    email = first_name[0] + last_name + str(i) + "@gmail.com"
    birth_date = str(rng(1940, 1996)) + '-' + str(rng(1, 12)) + '-' + str(rng(1, 27))
    password = create_text(15)
    profile_photo = first_name + last_name + str(i) + ".jpeg"
    profile_bio = create_text(50)
    join_date = '2008-' + str(rng(1, 12)) + '-' + str(rng(1, 27))
    val = (u_id, handle, first_name, last_name, email, birth_date, password, profile_photo, profile_bio, join_date)
    mycursor.callproc("insert_into_user", val)
    #mycursor.execute(sql, val)
    mydb.commit()

# Prepare insertions of 1-way follow tuples from the trimmed follows.txt

#sql1 = "INSERT INTO follows (user_id, user_followed_id) VALUES (%s, %s)"

with open('follows.txt', 'r') as file:
    for line in file:
        line = line.strip()
        info = line.split(" ")
        userA = "U" + str(info[0]).rjust(8, '0')
        userB = "U" + str(info[1]).rjust(8, '0')
        val1 = (userA, userB)
        mycursor.callproc("insert_into_follows", val1)
        #mycursor.execute(sql1, val1)
        mydb.commit()
        
file.close()

# Prepare insertions of comments, as well as posts, based on known replies
# from userA to userB in the trimmed comments.txt
#sql2 = "INSERT INTO comment (comment_id, user_id, post_id, ref_comment_id, text, timestamp) VALUES (%s, %s, %s, %s, %s, %s)"

with open('comments.txt', 'r') as file:
    for line in file:
        line = line.strip()
        info = line.split(" ")
        userA = "U" + str(info[0]).rjust(8, '0')
        userB = "U" + str(info[1]).rjust(8, '0')

        comment_id = "C" + str(comment_num).rjust(16, '0')
        comment_num += 1

        user_id = userA
        target_user_id = userB

        post_id, ref_comment_id, timestamp = choose_receiver_of_comment_or_share(userB, post_num)
        text = create_text(140)
        timestamp = next_day(timestamp)
        val2 = (comment_id, user_id, post_id, ref_comment_id, text, timestamp)
        mycursor.callproc("insert_into_comment", val2)
        #mycursor.execute(sql2, val2)
        mydb.commit()
        
file.close()

# Prepare share of post/comments, as well as new posts when convenient, 
# based on known shares of userB from userA in the trimmed shares.txt
#sql3_v1 = "INSERT INTO share_post (user_id, post_id, timestamp) VALUES (%s, %s, %s)"
sql3_v1 = "user_share_post"
#sql3_v2 = "INSERT INTO share_comment (user_id, comment_id, timestamp) VALUES (%s, %s, %s)"
sql3_v2 = "user_share_comment"

with open('shares.txt', 'r') as file:
    for line in file:
        line = line.strip()
        info = line.split(" ")
        userA = "U" + str(info[0]).rjust(8, '0')
        userB = "U" + str(info[1]).rjust(8, '0')

        user_id = userA
        target_user_id = userB

        post_id, ref_comment_id, timestamp = choose_receiver_of_comment_or_share(userB, post_num, 1)

        if ref_comment_id == None:
            sql3, val3 = sql3_v1, (user_id, post_id, next_day(timestamp))
        else:
            sql3, val3 = sql3_v2, (user_id, ref_comment_id, next_day(timestamp))

        mycursor.callproc(sql3, val3)
        #mycursor.execute(sql3, val3)
        mydb.commit()
        
file.close()