import random
from random import randrange, uniform, randint, choice
import re


def generate_surnames_and_names(num):
    names = [
        'Гарик', 'Тимур', 'Демис', 'Сергей', 'Михаил',
        'Алексей', 'Александр', 'Геннадий', 'Юлия',
        'Анна', 'Юрий', 'Владимир', 'Василий', 'Людмила',
        'Максим', 'Андрей', 'Иван', 'Дмитрий'
    ]

    woman = [
        'Анна', 'Юлия', 'Людмила'
    ]

    patronymics = [
        'Михайлович', 'Александрович', 'Максимович', 'Артемович',
        'Матвеевич', 'Даниилович', 'Иванович', 'Дмитриевич', 'Тимофеевич',
        'Романович', 'Кириллович', 'Константинович', 'Ильич', 'Егорович',
        'Алексеевич', 'Андреевич', 'Федорович', 'Владимирович', 'Тимурович'
    ]

    surnames = ['Мартирасян', 'Брекоткин', 'Карибидис', 'Харламов',
                'Батрудинов', 'Ревва', 'Кожома', 'Светлаков',
                'Галустян', 'Слепаков', 'Гудков', 'Варнава',
                'Галыгин', 'Ярушин', 'Башкатов', 'Масляков'
                ]

    roles = [
        'Капитан', 'Ведущий', 'Актер',
        'Автор', 'Звукорежиссер', 'Администратор', 'Реквизитор', 'Чирлидер'
    ]

    for id in range(num):
        phone_num = '89'
        for i in range(9):
            phone_num += str(randint(0, 9))

        role = choice(roles)

        surname = random.choice(surnames)
        name = random.choice(names)
        patronimic = random.choice(patronymics)
        print(
            f"({id + 1}, '{surname} {name} {patronimic if name not in woman else re.sub('ич', 'на', patronimic)}', {phone_num}, '{role}'),")


# Generate 40 fills for kvn.personal
# generate_surnames_and_names(40)

def date():
    return f"TIMESTAMP '{randint(2021, 2023)}-{randint(1, 12):02}-{randint(1, 28):02}'"


def player():
    for i in range(10):
        for j in range(4):
            print(f"({i + 1}, {i * 4 + j + 1}, {date()}),")


# player()


def parse(text_file):
    leagues = []
    cities = []
    with open(text_file, 'r', encoding='utf-8') as f:
        while l := f.readline():
            print(l)

            if l == '\n':
                continue
            l = l.replace("\n", '')
            s = l.split(', ')
            leagues.append(s[0])
            if ', ' in l:
                cities.append(s[1])
    leagues = list(set(leagues))
    cities = list(set(cities))
    for i in range(len(leagues)):
        print(f"{leagues[i]},", end=' ')
    print('----------')
    for i in range(len(cities)):
        print(f"{cities[i]},", end=' ')
    # print('----------')
    # for i in range(len(leagues)):
    #     for j in range(2021, 2024):
    #         print(f"({i + 1}, {j}),")


parse("input.txt")


def state():
    teams = [
        'Университетские шутники',
        'Городские комедианты',
        'Университетский юмор',
        'Городские комики',
        'Городские шутки',
        'Университетские клоуны',
        'Университетская комедия',
        'Городские смешарики',
        'Университетские шутницы',
        'Городские забавы'
    ]

    for i in range(1, 8):
        for year in range(2022, 2024):
            random.shuffle(teams)
            for place in range(1, 4):
                print(f"({i}, {year}, {randint(1, 10)}, {place}),")

    for i in range(1, 78):
        print(f"({i}),")


# state()


def game():
    names = (
        'Усть-Каменогорск - центр планеты',
        'В здоровом теле - здоровый юмор',
        'Декабрьский позитив',
        'Молодо-зелено',
        'Жизнь прекрасна!',
        'Здравствуйте, я ваша тетя',
        'Коктейль в стиле КВН',
        'КВН в условиях мирового кризиса',
        'Юмор согревает',
        'Смех без причины',
        'Зима зимой, а лето летом!',
        'Зима зимой, а смех по расписанию',
        'Весела зима, для юмора пора',
        'Если бы КВН проводился на морозе!',
        'Новый год-Новый КВН',
        'Мы снова верим в чудеса!',
        'ЗИМНЯЯ СКАЗКА'
    )
    random.shuffle(names)
    start = 24
    for i in range(len(names)):
        x = randint(2021, 2023)
        print(
            f"({start}, '{names[i] + ' ' + str(x)}', {randint(1, 77)}, "
            f"TIMESTAMP '{x}-{randint(1, 12):02}-{randint(1, 28):02}', "
            f"{randint(1, 60)}),")
        start += 1


# game()


def city():
    bools = [
        True,
        False
    ]
    for i in range(12, 59):
        print(
            f"({i + 1}, point({round(uniform(40, 60), 6)}, {round(uniform(30, 60), 6)}), {randint(100000, 150000000) // 1000}, {random.choice(bools)}),")


# city()


def viewer():
    for i in range(22, 41):
        print(f"({i}, {randint(100, 15000000) // 1000}, {randint(100000, 150000000) // 1000}),")


# viewer()


def result():
    a = [i for i in range(1, 11)]
    l = 64
    for i in range(22, 41):
        random.shuffle(a)
        for place in range(1, 4):
            print(f"({l}, {i}, {place}, {a[place]}, {True if place <= 2 else False}),")
            l += 1


# result()


def score():
    for i in range(64, 121):
        for rnd in range(1, 3):
            print(f"({i}, {rnd}, {round(uniform(1, 5), 1)}),")


# score()


def gen_date(num):
    s = []
    while num:
        x = random.randint(1, 19)
        y = random.randint(1, 30)
        if (x, y) not in s:
            print(f"({x}, {y}),")
            num -= 1
            s.append((x, y))


# gen_date(84)


def gen_find(num):
    for _ in range(num):
        c = random.randint(0, 10)
        y = random.randint(1980, 2019)
        m = random.randint(1, 12)
        d = random.randint(1, 28)
        print(
            f"({c}, '', '{y}-{m:02}-{d:02}', {random.randint(1, 10)}, {random.randint(1, 10)}, {random.randint(1, 10)}),")


# gen_find(30)


def tmp():
    for i in range(1, 78):
        for j in range(3):
            print(f"({i}),")
# tmp()
