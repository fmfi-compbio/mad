---
title: Lsql
---

* TOC
{:toc}

[HWsql](./HWsql.md)

This lecture introduces the basics of the Python programming language
and the basics of working with databases using the SQL language and
SQLite3 lightweight database system.

The next three lectures

  - Computer science and data science students will use Python, SQLite3
    and several advanced Python libraries for complex data processing.
  - Bioinformatics students will use several bioinformatics command-line
    tools.

## Overview, documentation

**Outline of this lecture**

  - We introduce a simple data set.
  - In a separate [tutorial](./Python.md) for beginners in Python,
    we have several Python scripts for processing this data set.
  - We introduce basics of working with SQLite3 and writing SQL queries.
  - We look at how to combine Python and SQLite.

**SQL**

  - SQL is a language for working with relational databases. It is
    covered in more detail in dedicated database courses.
  - We will cover basics of SQL and work with a simple DB system
    SQLite3.
  - Advantages of storing data in a database rather than CSV files and
    similar:
      - A database can contain multiple tables and connect them through
        shared identifiers.
      - You can create indices which allow fast access to records
        matching your criteria without searching through all data.
      - A database system can compute complex queries without loading
        all data into memory.
  - Typical database systems are complex, use server-client
    architecture. In contrast, SQLite3 is a simple "database" stored in
    one file.
      - It is best used by a single process at a time, although multiple
        processes can read concurrently.
      - It can be easily created, does not need extensive configuration
        typical for more complex database systems.
  - [SQLite3 documentation](https://www.sqlite.org/docs.html)
  - [SQL tutorial](https://www.w3schools.com/sql/default.asp)
  - [SQLite3 in Python
    documentation](https://docs.python.org/3/library/sqlite3.html)

## Dataset for this lecture

  - [IMDb](https://www.imdb.com/) is an online database of movies and TV
    series with user ratings.
  - We have downloaded a preprocessed dataset of selected TV series
    ratings from [GitHub](https://github.com/nazareno/imdb-series/).
  - From this dataset, we have selected 10 series with high average
    number of voting users.
  - Data are two files in the CSV format: list of series, list of
    episodes.
  - CSV stands for comma-separated values.

File `series.cvs` contains one row per series

  - Columns: (0) series id, (1) series title, (2) TV channel:

<!-- end list -->

    3,Breaking Bad,AMC
    2,Sherlock,BBC
    1,Game of Thrones,HBO 

File `episodes.csv` contains one row per episode:

  - Columns: (0) series id, (1) episode title, (2) episode order within
    the whole series, (3) season number, (4) episode number within
    season, (5) user rating, (6) the number of votes
  - Here is a sample of 4 episodes from the Game of Thrones series.
  - If the episode title contains a comma, the whole title is in
    quotation marks.

<!-- end list -->

    1,"Dark Wings, Dark Words",22,3,2,8.6,12714
    1,No One,58,6,8,8.3,20709
    1,Battle of the Bastards,59,6,9,9.9,138353
    1,The Winds of Winter,60,6,10,9.9,93680

**Notes**

  - A different version of this data was used already in the [lecture on
    Perl](./Lperl#The_first_input_file_for_today:_TV_series.md).
  - A [Python tutorial](./Python.md) shows several scripts for
    processing these files which are basically longer versions of some
    of the SQL queries below.

## SQL and SQLite

### Creating a database

SQLite3 database is a file with your data stored in a special format. To
load our csv files to a SQLite database, run command:

``` bash
sqlite3 series.db < create_db.sql
```

Contents of `create_db.sql` file:

``` sql
CREATE TABLE series (
  id INT,
  title TEXT,
  channel TEXT
);
.mode csv
.import series.csv series
CREATE TABLE episodes (
  seriesId INT,
  title TEXT,
  orderInSeries INT,
  season INT,
  orderInSeason INT,
  rating REAL,
  votes INT
);
.mode csv
.import episodes.csv episodes
```

  - The two `CREATE TABLE` commands create two tables named `series` and
    `episodes`.
  - For each column (attribute) of the table we list its name and type.
  - Commands starting with a dot are special SQLite3 commands, not part
    of SQL itself. Command `.import` reads a CSV file and stores it in a
    table.

Other useful SQLite3 commands;

  - `.schema tableName` (lists columns of a given table)
  - `.mode column` and `.headers on` (turn on human-friendly formatting,
    not good for further processing)

### SQL queries

  - Run `sqlite3 series.db` to get an SQLite command-line where you can
    interact with your database.
  - Then type the queries below which illustrate the basic features of
    SQL.
  - In these queries, we use uppercase for SQL keywords and lowercase
    for our names of tables and columns (SQL keywords are not case
    sensitive).

<!-- end list -->

``` sql
/*  switch on human-friendly formatting */
.mode column
.headers on

/* print title of each series (as prog1.py) */
SELECT title FROM series;

/* sort titles alphabetically */
SELECT title FROM series ORDER BY title;

/* find the highest vote number among episodes */
SELECT MAX(votes) FROM episodes;

/* find the episode with the highest number of votes, as prog3.py */
SELECT title, votes FROM episodes
  ORDER BY votes DESC LIMIT 1;

/* print all episodes with at least 50k votes, order by votes */
SELECT title, votes FROM episodes
  WHERE votes>50000 ORDER BY votes DESC;

/* join series and episodes tables, print 10 episodes
 * with the highest number of votes */
SELECT s.title, e.title, votes
  FROM episodes AS e, series AS s
  WHERE e.seriesId=s.id
  ORDER BY votes DESC 
  LIMIT 10;

/* compute the number of series per channel, as prog2.py */
SELECT channel, COUNT() AS series_count
  FROM series GROUP BY channel;

/* print the number of episodes 
   and average rating per season and series,
   using only seasons with at least 6 episodes */
SELECT seriesId, season, COUNT() AS episode_count, 
       AVG(rating) AS avg_rating
  FROM episodes 
  GROUP BY seriesId, season 
  HAVING episode_count >= 6;
```

Parts of a typical SQL query:

  - `SELECT` followed by column names, or functions `MAX`, `COUNT` etc.
    These columns or expressions are printed for each row of the table,
    unless filtered out (see below). Individual columns of the output
    can be given aliases by keyword `AS`.
  - `FROM` followed by a list of tables. Tables also can get aliases
    (`FROM episodes AS e`).
  - `WHERE` followed by a condition used for filtering the rows.
  - `ORDER BY` followed by an expression used for sorting the rows,
    `DESC` means descending (from largest to smallest).
  - `LIMIT` followed by the maximum number of rows to print.

More complicated concepts:

  - If you list two tables in `FROM`, you will conceptually create all
    pairs of rows, one from one table, one from the other. These are
    then typically filtered in the `WHERE` clause to only those that
    have a matching ID (for example `WHERE e.seriesId=s.id` in one of
    the queries above).
  - `GROUP BY` allows to group rows based on common value of some
    columns and compute statistics per group (count, maximum, sum etc).
    Groups to be printed can be further filtered using `HAVING` keyword
    which can be applied to these statistics.

## Accessing a database from Python

We will use [`sqlite3`](https://docs.python.org/3/library/sqlite3.html)
library for Python to access data from the database and to process them
further in the Python program.

### read\_db.py

  - The following script illustrates running a `SELECT` query and
    getting the results.
  - To start using a database, we first create objects called Connection
    and Cursor. We use the cursor to run individual SQl queries.
  - If we want to use particular values in the queries, which we have
    stored in variables, we use
    [placeholders](https://docs.python.org/3/library/sqlite3.html#how-to-use-placeholders-to-bind-values-in-sql-queries)
    "?" in the query itself and pass the values to the `execute` command
    as a tuple.
      - sqlite3 module ensures that the values are passed to the
        database correctly. If we inserted the values directly into the
        query string, we could face problems if the values contain e.g.
        quotation marks leading to SQL syntax errors or even [SQL
        injection attacks](https://en.wikipedia.org/wiki/SQL_injection).

<!-- end list -->

``` python
import sqlite3

# connect to a database 
connection = sqlite3.connect('series.db')
# create a "cursor" for working with the database
cursor = connection.cursor()

# run a select query
# supply parameters of the query using placeholders ?
threshold = 40000
cursor.execute("""SELECT title, votes FROM episodes
  WHERE votes>? ORDER BY votes desc""", (threshold,))

# retrieve results of the query
for row in cursor:
    print(f"Episode \"{row[0]}\" votes {row[1]}")
    
# close db connection
connection.close()
```

### write\_db.py

This script illustrates creating a new database containing a
multiplication table.

  - When we modify the database, it is important to run `commit` command
    to actually write them to the disk.
  - We use a [command-line
    argument](./Python#Command-line_arguments.md) to get the name
    of the file with the database from the user

<!-- end list -->

``` python
import sqlite3
import argparse

# create parser of arguments
parser = argparse.ArgumentParser()
# add one required argument giving the name of a file
parser.add_argument('filename', help='Name of a file to write')
# parse the argument into args namespace
args = parser.parse_args()

# connect to a database using the name from the argument
connection = sqlite3.connect(args.filename)
# create a "cursor" for working with the database
cursor = connection.cursor()

cursor.execute("""
CREATE TABLE mult_table (
a INT, b INT, mult INT)
""")

for a in range(1,11):
    for b in range(1,11):
        cursor.execute("INSERT INTO mult_table (a, b, mult) VALUES (?, ?, ?)",
                       (a, b, a * b))

# important: save the changes
connection.commit()
    
# close db connection
connection.close()
```

We can run this script and check the result as follows:

``` bash
python3 write_db.py multiplication.db
sqlite3 multiplication.db "SELECT * FROM mult_table"
```

