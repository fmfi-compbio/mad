---
title: HWweb
---

* TOC
{:toc}

See [the lecture](./Lweb.md)

Submit by copying requested files to `/submit/web/username/`

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

  - `db.sqlite3` - the database
  - `schema.txt` - a brief description of your schema and rationale
    behind it

### Task B

Build a crawler, which crawls comments in pravda.sk discussions. You
have two options:

  - For fewer points: Script which gets URL of a user (e.g.
    <https://debata.pravda.sk/profil/debata/anysta/>) and crawls the
    comments of this user from the last month.
  - For more points: Scripts which gets one starting URL (either user
    profile or some discussion, your choice) and automatically discovers
    users and crawls their comments.

This crawler should store the comments in SQLite3 database built in the
previous task.

Submit the following:

  - `db.sqlite3` - the database
  - every python script used for crawling
  - `README` (how to start your crawler)

