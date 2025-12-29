---
title: HWsql
---

* TOC
{:toc}

See also the [lecture](./Lsql.md) and [Python
tutorial](./Python.md).

### Introduction

  - Task A: introduction to Python
  - Tasks B1, B2: introduction to SQL
  - Task C: Python+SQL
  - Task D: SQL and optionally also Python

**If you are a beginner in Python (not DAV and BIN students\!), do tasks
A,B1,B2,C. Otherwise do tasks B1,B2,C,D.**

### Preparation and submitting

Before you start working, copy files to your home folder:

``` bash
mkdir sql
cd sql
cp -iv /tasks/sql/* .
```

The folder contains the following files:

  - `*.py`: scripts from the Python tutorial, included for convenience
  - `series.csv`, `episodes.csv`: data files introduced in the lecture
  - `create_db.sql`: SQL commands to create the database needed in tasks
    B1, B2, C, D
  - `protocol.txt`: fill in and submit the protocol.

Submit by copying requested files to `/submit/sql/username/` as follows
(use the version for beginners or non-beginners):

``` bash
# for beginners in Python:
cp -ipv protocol.txt taskA.py taskA.txt taskB1.sql taskB1.txt taskB2.sql taskB2.txt taskC.py series.db series2.db /submit/sql/username/

# for non-beginners in Python:
cp -ipv protocol.txt taskB1.sql taskB1.txt taskB2.sql taskB2.txt taskC.py series.db series2.db taskD.py taskD.sql taskD.txt /submit/sql/username/
# one of taskD.py and taskD.sql will be missing
# this is ok
```

### Task A (Python)

Write a script `taskA.py` which reads both csv files and outputs for
each TV channel the total number of episodes in their series combined.
Run your script as follows:

``` bash
python3 taskA.py > taskA.txt
```

One of the lines of your output should be:

    The number of episodes for channel "HBO" is 76

**Submit** file `taskA.py` with your script and the output file
`taskA.txt`:

Hints:

  - A good place to start is `prog4.py` with reading both csv files and
    `prog2.py` with a dictionary of counters.
  - It might be useful to build a dictionary linking the series id to
    the channel name for that series.

### Task B1 (SQL)

To **prepare the database** for tasks B1, B2, C and D, run the command:

``` bash
sqlite3 series.db < create_db.sql
```

To verify that your database was created correctly, you can run the
following commands:

``` bash
sqlite3 series.db ".tables"
# output should be  episodes  series  

sqlite3 series.db "select count() from episodes; select count() from series;"
# output should be 348 and 10
```

The **task** here is to extend the [last query in the
lecture](./Lsql#SQL_queries.md), which counts the number of
episodes and average rating per each season of each series:

``` sql
SELECT seriesId, season, COUNT() AS episode_count, AVG(rating) AS rating
  FROM episodes GROUP BY seriesId, season;
```

Use join with the `series` table to replace the numeric series id with
the series title and add the channel name. Write your SQL query to file
`taskB1.sql`. The first two lines of the file should be

``` sql
.mode column
.headers on
```

Run your query as follows:

``` bash
sqlite3 series.db < taskB1.sql > taskB1.txt
```

For example, both seasons of True Detective by HBO have 8 episodes and
average ratings 9.3 and 8.25

``` 
True Detective   HBO         1           8              9.3       
True Detective   HBO         2           8              8.25      
```

**Submit** `taskB1.sql` and `taskB1.txt`

### Task B2 (SQL)

For each channel, compute the total count and average rating of all
their episodes. Write your SQL query to file `taskB2.sql`. As before,
the first two lines of the file should be

``` sql
.mode column
.headers on
```

Run your query as follows:

``` bash
sqlite3 series.db < taskB2.sql > taskB2.txt
```

For example, all 76 episodes for the two HBO series have average rating
as follows:

    HBO         76          8.98947368421053

**Submit** `taskB2.sql` and `taskB2.txt`

### Task C (Python+SQL)

If you have not done so already, create the SQLite3 database, as
explained at the beginning of [task B1](#Task_B1_\(SQL\) "wikilink").

In this task you should write a script `taskC.py` that will combine

  - processing command-line arguments, and
  - reading and writing SQLite3 database from Python.

Your script should run the last query from the lecture (shown below) and
store its results in a separate table called `seasons` in the same
database file.

``` sql
/* print the number of episodes 
   and average rating per season and series,
   using only seasons with at least 6 episodes */
SELECT seriesId, season, COUNT() AS episode_count, 
       AVG(rating) AS avg_rating
  FROM episodes 
  GROUP BY seriesId, season 
  HAVING episode_count >= 6;
```

Command-line arguments of your script:

  - one required argument giving name of the file with the database
    (e.g. `series.db`)
  - an optional argument `min_count` (switch `-m`) with default value 6
    which gives the minimum episode count in a season to be printed. Use
    this value instead of constant 6 in the query above.

An example with similar arguments is in `argument_example.py` (see
[Python tutorial](./Python#Command-line_arguments.md).

  - At the start of your script, execute SQL command `DROP TABLE IF
    EXISTS seasons`, which will erase attempts from previous runs of
    your script. Afterwards execute SQL `CREATE TABLE` command for
    creating `seasons` table with appropriate column names and types to
    store the result of the query.
  - Use
    [placeholder](https://docs.python.org/3/library/sqlite3.html#how-to-use-placeholders-to-bind-values-in-sql-queries)
    `"?"` in the `SELECT` query to insert `min_count` value (as in
    [read\_db.py](./Lsql#read_db.py.md) from the lecture).
  - Read each row of the `SELECT` query in Python and store it by
    running `INSERT` command from Python. (SQL can
    [store](https://www.sqlite.org/lang_insert.html) the results from a
    query directly in a table, but in this task you should use Python
    instead.)
  - The cursor from the `SELECT` query is needed while you iterate over
    the results. Therefore create two cursors: one for reading the
    database and one for writing.
      - The SQLite3 library in Python has some [implicit
        transactions](https://docs.python.org/3/library/sqlite3.html#transaction-control),
        so you may end up with some locking errors. We recommend the
        following order of commands: (1) create connection and two
        cursors, (2) run `DROP TABLE` and `CREATE TABLE` commands,
        commit changes, (3) run `SELECT` command on one of the cursors,
        (4) as you iterate through results of `SELECT`, run `INSERT` on
        the second cursor, (4) commit changes. You could also commit
        after each `INSERT`.

To test your script, run the following sequence of commands

``` bash
# delete database if it exists
rm series.db
# create series.db as in task B1
sqlite3 series.db < create_db.sql
# create a copy of the database
cp series.db series2.db

# run your script on series.db with default min_count=6
python3 taskC.py series.db
# the following line prints the number of records in your table
#   it should be 29
sqlite3 series.db "SELECT count(*) FROM seasons"

# run your script on series2.db with min_count=10
python3 taskC.py --min_count=10 series2.db
# here the number of lines should be 22
sqlite3 series2.db "SELECT count(*) FROM seasons"
```

To further check your table, print all rows of your table:

``` bash
sqlite3 series.db "SELECT * FROM seasons"
```

One of the lines printed should be `"5|1|8|9.3"` which is for season 1
of series 5 (True Detective) with 8 episodes.

**Submit** your script `taskC.py` and the modified databases `series.db`
and `series2.db`.

### Task D (SQL, optionally Python)

For each pair of consecutive seasons within each series, compute how
much has the average rating increased or decreased.

  - For example in the Sherlock series, season 1 had rating 8.825 and
    season 2 rating 9.26666666666667, and thus the difference in ratings
    is 0.44166666666667
  - Print a table containing series name, season number x, average
    rating in season x and average rating in season x+1
  - The table should be ordered by the difference between the last two
    columns, i.e. from seasons with the highest increase to seasons with
    the highest drop.
  - One option is to run a query in SQL in which you join the `seasons`
    table from task C with itself and select rows that belong to the
    same series and successive seasons.
  - You can also read the rows of the `seasons` table in Python, combine
    information from rows for successive seasons of the same series and
    create the final report by sorting.
  - **Submit** your code as `taskD.py` or `taskD.sql` and the resulting
    table as `taskD.txt`

The output should start like this (the formatting may differ):

``` 
series      season x    rating for x  rating for x+1  
----------  ----------  ------------  ----------------
Sherlock    1           8.825         9.26666666666667
Breaking B  4           9.0           9.375           
```

When using SQL without Python, include the following two lines in
`taskD.sql`

``` sql
.mode column
.headers on
```

and run your query as `sqlite3 series.db < taskD.sql > taskD.txt`

