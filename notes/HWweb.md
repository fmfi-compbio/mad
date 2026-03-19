---
title: HWweb
---

* TOC
{:toc}

See [the lecture](./Lweb.md)

* Submit by copying requested files to `/submit/web/username/`
* Outline of the protocol can be found in `/tasks/web/protocol.txt`

**General goal:** Scrape comments from user discussions at the
`pravda.sk` website. Store comments from several (hundreds) users from
the last month in an SQLite3 database.

### Task A

Create SQLite3 "database" with appropriate schema for storing comments
from pravda.sk discussions. For each comment you should be able to tell
its content, date, time and who wrote it. You don't need to store which
comment replies to which one. For each user you should be able to
retrieve her/his comments and also her/his name. You will probably need
tables for users and comments.

Submit two files:

  - `db.sqlite3` - the database (including any data stored in Task B)
  - `create_db.sql` - a script to create the database schema (can be similar to the script `/tasks/sql/create_db.sql` from earlier tasks)

The database should be initialized by the following command:
```bash
sqlite3 db.sqlite3 < create_db.sql
```

In the protocol, also describe your schema and rationale behind it. 

### Task B

Build a crawler, which crawls comments in pravda.sk discussions. You
have two options:
  - For fewer points: Script which gets URL of a user as a command-line argument (e.g.
    <https://debata.pravda.sk/profil/debata/maxlll/>) and crawls the
    comments of this user from the last month.
  - For more points: Scripts which gets one starting URL (either user
    profile or some discussion, your choice) and automatically discovers
    users and crawls their comments.

This crawler should store the comments in SQLite3 database built in the
previous task. 

Submit the following:

  - `db.sqlite3` - the database
  - `crawler.py` - the crawler script
  - you may submit any additional files you need for your crawler, but make sure to include in the protocol a description of each file

In the protocol, also show commannds you used to run you crawler. These commands should run successfully on the server, using only libraries available there.

### Task C

Use simple SQL queries to show the basic statistics of your database from task B, such as the total number of records in each table. Also show an example record from each table (you can use clause `LIMIT 1` in your queries to obtain an example). 

Write your queries and their results in the protocol.