import random
from random import randrange, uniform, randint, choice
import re
import codecs
import psycopg2
from tqdm import tqdm
from random_username.generate import generate_username
from db import db_connection, execute_query, copy_data, print_data


def date(year=0):
    return f"'{year if year != 0 else randint(1961, 2023)}-{randint(1, 12):02}-{randint(1, 28):02}'"


tables = open('tables', 'r+')
for line in tables:
    print(line, end='')
connect = db_connection()
# execute_query(connect, "tables")

# users = generate_username(10000)
# file = codecs.open("users.txt", "w+", "utf-8")
# for x in users:
#     file.write(x + '\n')
# file.close()
with open('leagues.txt', 'r+', encoding='utf-8') as f:
    leagues = list(f.readline().split(','))
    f.close()
with open('cities.txt', 'r+', encoding='utf-8') as f:
    cities = list(f.readline().split(','))
    f.close()
leagues = list(map(str.strip, leagues))
cities = list(map(str.strip, cities))
with open('roles.txt', 'r+', encoding='utf-8') as f:
    roles = [line.rstrip() for line in f]
    f.close()
with open('comments.txt', 'r+', encoding='utf-8') as f:
    comments = [line.rstrip() for line in f]
    f.close()
with open('names.txt', 'r+', encoding='utf-8') as f:
    names = [line.rstrip() for line in f]
    f.close()
with open('women.txt', 'r+', encoding='utf-8') as f:
    women = [line.rstrip() for line in f]
    f.close()
with open('surnames.txt', 'r+', encoding='utf-8') as f:
    surnames = [line.rstrip() for line in f]
    f.close()
with open('patronymics.txt', 'r+', encoding='utf-8') as f:
    patronymics = [line.rstrip() for line in f]
    f.close()
with open('teams.txt', 'r+', encoding='utf-8') as f:
    teams = [line.rstrip() for line in f]
    f.close()
with open('games.txt', 'r+', encoding='utf-8') as f:
    games = [line.rstrip() for line in f]
    f.close()
file = codecs.open("game_names.txt", "w+", "utf-8")
for i in range(1000000):
    file.write(choice(cities) + ' ' + choice(games) + ' ' + str(randint(1961, 2023)) + '\n')
file.close()
with open('game_names.txt', 'r+', encoding='utf-8') as f:
    game_names = [line.rstrip() for line in f]
    f.close()
with open('users.txt', 'r+', encoding='utf-8') as f:
    users = [line.rstrip() for line in f]
    f.close()

# execute_query(connect, "begin.txt")
# file = codecs.open("file.txt", "w+", "utf-8")
# for i in tqdm(range(1, 1000001)):
#     x = game_names[i % 1000000]
#     city = x.split()[0]
#     year = x.split()[-1]
#     file.write(f'{x}' + '\t')
#     file.write(choice(leagues) + '\t')
#     file.write(date(year) + '\t')
#     file.write('{')
#     for j in range(10):
#         file.write(str((i + j) % 178 + 1))
#         if j != 9:
#             file.write(', ')
#     file.write('}\t')
#     file.write('{')
#     for j in range(10):
#         file.write(teams[((i + j) % 178)])
#         if j != 9:
#             file.write(', ')
#     file.write('}\t')
#     name = choice(names)
#     surname = choice(surnames)
#     patronymic = choice(patronymics)
#     file.write(
#         f"{surname if name not in women else surname + 'а' if surname[-1] == 'в' else surname} "
#         f"{name} {patronymic if name not in women else re.sub('ич', 'на', patronymic)}\t")
#     file.write(f'{randint(100, 15000000) // 1000}\t')
#     file.write(f'{randint(100000, 150000000) // 1000}\t')
#     file.write(city + '\n')
# file.close()
# copy_data(connect, "COPY kvn.game(game_name, league_name, date, team_ids, team_names, "
#                    "host_name, online_views, offline_views, city) FROM E'D:\\\\pythonProject\\\\Secure "
#                    "Sight\\\\file.txt';")
# execute_query(connect, "commit.txt")

# execute_query(connect, "begin.txt")
# file = codecs.open("filecon.txt", "w+", "utf-8")
# for i in tqdm(range(1, 1000001)):
#     file.write(f'{i % 100000 + 1}' + '\t')
#     file.write(f'{i % 178 + 1}' + '\n')
# file.close()
# copy_data(connect, "COPY kvn.connect FROM E'D:\\\\pythonProject\\\\Secure "
#                    "Sight\\\\filecon.txt';")
# execute_query(connect, "commit.txt")

# execute_query(connect, "begin.txt")
# file = codecs.open("file3.txt", "w+", "utf-8")
# for i in tqdm(range(178)):
#     file.write(f'{teams[i]}' + '\t')
#     file.write('{')
#     random.shuffle(roles)
#     for j in range(5):
#         phone_num = '89'
#         for f in range(9):
#             phone_num += str(randint(0, 9))
#         name = choice(names)
#         surname = choice(surnames)
#         patronymic = choice(patronymics)
#         file.write("\"%s\": {\"Фамилия\": \"%s\", \"Имя\": \"%s\", \"Отчество\": \"%s\", \"Возраст\": %d, "
#                    "\"Телефон\": \"%s\"}" %
#                    (roles[j], surname if name not in women else surname + 'а' if surname[-1] == 'в' else surname,
#                     name, patronymic if name not in women else re.sub('ич', 'на', patronymic),
#                     randint(18, 40), phone_num))
#         if j != 4:
#             file.write(', ')
#     file.write('}\n')
# file.close()
# copy_data(connect, "COPY kvn.team(team_name, team_info) "
#                    "FROM E'D:\\\\pythonProject\\\\Secure Sight\\\\file3.txt';")
# execute_query(connect, "commit.txt")

for i in range(10):
    execute_query(connect, "begin.txt")
    file = codecs.open("file2.txt", "w", "utf-8")
    for i in tqdm(range(1, 1000001)):
        year = int(game_names[i % 1000000].split()[-1]) + 1
        file.write(f'{i % 100000 + 1}' + '\t')
        file.write(f'{game_names[i % 1000000]}' + '\t')
        file.write(choice(comments) + '\t')
        file.write(date(year) + '\t')
        file.write(str(randint(0, 5)) + '\t')
        file.write("{\"Ник\": \"%s\", \"Возраст\": \"%d\", \"Город\": \"%s\"}\n" %
                   (choice(users) + str(randint(0, 100000)), randint(7, 90), choice(cities)))
    file.close()
    copy_data(connect, "COPY kvn.feedback(game_id, game_name, comment, date, rate, viewer_info) "
                       "FROM E'D:\\\\pythonProject\\\\Secure Sight\\\\file2.txt';")
    execute_query(connect, "commit.txt")


# execute_query(connect, "tables_end")

connect.commit()
connect.close()
