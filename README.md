# MSU-Database-Prac

This repository is devoted to **Data Bases MSU Practicum**.

**Mastered themes:**
1. **Theoretics** of building database systems, data modeling and data management methods using the SQL language and other modern DBMS tools,
2. **Relational** databases and database management systems.

**My DataBase Theme:** ***[KVN](https://en.wikipedia.org/wiki/KVN)***

**Practicum Tasks:**
- **1:** Get acquainted with the pgAdmin environment and **write
SQL queries using the SELECT statement**. For a model database, you must
4 arbitrary SELECT queries can be compiled to demonstrate the knowledge gained.
Requests should cover well-researched topics and be meaningful, i.e. solve
a useful problem from the subject area. After making the queries, you should make sure
that they are correct using simpler queries.
- **2.1:** **Design the database schema** for the operation
of the application (WEB /Mobile / Desktop). Each individual option contains
a preset area from which the database to be designed should be. The student's task
is to decide what the database being created will be used for, and, based
on this, build its conceptual scheme. The result of this practical task
is a database schema (in the form of an ER diagram containing tables and relationships between
them, without specifying column types).
- **2.2:** Prepare an **SQL script** for **creating tables according to the scheme** obtained from the previous task, with specification of column types. Primary and foreign keys should be defined, as well as declarative integrity constraints (ability to accept undefined values, unique keys, time constraints, etc.) should be set up. The tables should be created in a separate database, and the data should be prepared to be inserted into the created tables, with a minimum of 10 entries for each core entity and 20 for each associative entity. Based on the prepared data, an SQL script should be made to insert the corresponding rows in the database tables.
- **2.3:** The fourth practical assignment involves **manipulating data using SQL operators**. To complete the assignment, you will need to:
    - Prepare 3-4 sample datasets that are relevant to the subject area, and write SQL queries for them.
    - Formulate 3-4 queries for modifying and deleting data from the database, based on the subject area and including integrity constraints.
    - Write SQL scripts to run these queries.
- **2.4:** The fifth practical task involves **data integrity control** using the **transaction mechanism** and **triggers**. You need to prepare SQL scripts to detect anomalies (such as lost changes, dirty reads, non-repeated reads, and phantom reads) while executing transactions at different levels of SQL/92 isolation (such as READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, and SERIALIZABLE). Two parallel sessions should be used to check for these anomalies, with each session executing the scripts step by step.
- **3.1:** The sixth practical task involves **designing a database schema** to **analyze** a popular application. We will start from the assumption that the database created in task No. 2.1 is very popular and statistical information can be gathered on it daily.
- **3.2:** The objective of the seventh practical task is to learn how to work with **views** and other **access control methods**. To complete the task, you need to:
    - Create a test user and give him access to the database. Create and run scripts to assign access rights to tables created in Practical Task No. 3.1 to the new user, with different access rights depending on the table.
- **3.3:** The eighth practical task is dedicated to simplifying analyst work by **creating and using
functions**.
- **3.4:** The ninth practical task focuses on **speeding up query execution** by using **partitioning**, **inheritance**, and **index mechanisms**.
- **2.2_dop_1:** **Correct tables** from task 2_2: remove unnecessary cascade dependencies. Also create **update** and **delete** scripts.
- **2.2_dop_2:** More decent way to **Correct tables** from task 2_2: remove unnecessary cascade dependencies. Also create **update** and **delete** scripts.
- **2.3_dop:** Create **function** in order to make team disqualifying easier.

## **Schemas**:
### Lab2 Schema:
![lab2](https://github.com/Championsh/MSU-Database-Prac/raw/main/lab2_1.png "Lab2 Schema")

### Lab3 Schema:
![lab2](https://github.com/Championsh/MSU-Database-Prac/raw/main/lab3_1.png "Lab3 Schema")

## Project Tree
```
├── DB Fill
│   ├── begin.txt
│   ├── cities.txt
│   ├── comments.txt
│   ├── commit.txt
│   ├── db_manipulation_functions.py
│   ├── execution_scripts.py
│   ├── games.txt
│   ├── generate_data.py
│   ├── input.txt
│   ├── leagues.txt
│   ├── names.txt
│   ├── patronymics.txt
│   ├── roles.txt
│   ├── sql_locations.txt
│   ├── surnames.txt
│   ├── tables
│   ├── tables_end
│   ├── task
│   ├── task2
│   ├── teams.txt
│   ├── users.txt
│   └── women.txt
├── .gitignore
├── lab1.sql
├── lab2_2_dop_1.sql
├── lab2_2_dop_2.sql
├── lab2_2.sql
├── lab2_3_dop.sql
├── lab2_3.sql
├── lab2_4_first.sql
├── lab2_4_second.sql
├── lab2_4_trigger_check.sql
├── lab2_4_trigger.sql
├── lab3_1.sql
├── lab3_2.sql
├── lab3_2_test.sql
├── lab3_3_function_1.sql
├── lab3_3_function_2.sql
├── lab3_4.sql
└── README.md
```

