import psycopg2


def db_connection():
    connection = psycopg2.connect(
        host='localhost',
        user='postgres',
        password='4103',
        database='postgres',
        port=5432,
        options="-c search_path=kvn,public"
    )
    print("PSQL Database connection successful")

    return connection


def execute_query(connection, file):
    cursor = connection.cursor()
    with open(file, 'r+', encoding='utf-8') as f:
        full_sql = f.read()
        sql_commands = full_sql.split(';')
        for sql_command in sql_commands:
            if len(sql_command.strip()) > 0:
                cursor.execute(sql_command.strip())
    connection.commit()
    cursor.close()
    print("Query success")


def copy_data(connection, query):
    cursor = connection.cursor()
    cursor.execute(query)
    cursor.close()
    connection.commit()
    print("Copy success")


def print_data(connection, file):
    cursor = connection.cursor()
    with open(file, 'r+', encoding='utf-8') as f:
        full_sql = f.read()
        sql_commands = full_sql.split(';')
        for sql_command in sql_commands:
            if len(sql_command.strip()) > 0:
                cursor.execute(sql_command.strip())
                records = cursor.fetchall()
                print(records)
    cursor.close()
    print("Print success")
