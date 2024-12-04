num = 10000

with open('higgs-social_network.edgelist', 'r') as file:
    with open('follows.txt', 'w') as file1:
        for line in file:
            line = line.strip()
            info = line.split(" ")
            if (int(info[0]) <= num) and (int(info[1]) <= num):
                string = info[0] + " " + info[1] + "\n"
                file1.write(string)
file.close()
file1.close()

with open('higgs-reply_network.edgelist', 'r') as re_file:
    with open('reply.txt', 'w') as re_out:
        for line in re_file:
            line = line.strip()
            info = line.split(" ")
            if (int(info[0]) <= num) and (int(info[1]) <= num):
                string = info[0] + " " + info[1] + "\n"
                re_out.write(string)
re_file.close()
re_out.close()

with open('higgs-retweet_network.edgelist', 'r') as share_file:
    with open('shares.txt', 'w') as share_out:
        for line in share_file:
            line = line.strip()
            info = line.split(" ")
            if (int(info[0]) <= num) and (int(info[1]) <= num):
                string = info[0] + " " + info[1] + "\n"
                share_out.write(string)
share_file.close()
share_out.close()