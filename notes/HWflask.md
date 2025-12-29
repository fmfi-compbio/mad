---
title: HWflask
---

* TOC
{:toc}

See [the lecture](./Lflask.md)

**General goal:** Build a simple website, which lists all crawled users
and for each users has a page with simple statistics regarding the posts
of this user.

Submit your source code (web server and preprocessing scripts) and
database files (even when you are using database from us). Copy these
files to `/submit/flask/username/`

This lesson requires crawled data from previous lesson. If you don't
have one, you can find it at `/tasks/flask/db.sqlite3`

### Task A

Create a simple Flask web application which:

  - Has a homepage with a list of all users (with links to their pages).
  - Has a page for each user with basic information: the nickname, the
    number of posts and the last 10 posts of this user.

<!-- end list -->

  - **Warning**: Next lecture homework depends on this task.

### Task B

Make a separate script which computes and stores in the database the
following information for each user:

  - the list of 10 most frequently used words,
  - the list of top 10 words typical for this user (words which this
    user uses much more often than other users). Come up with some
    simple heuristics for measuring this.

Show this information on the page of each user.

Hint: To get the most frequently used words for each user, you can use
[argsort from
NumPy.](http://docs.scipy.org/doc/numpy/reference/generated/numpy.argsort.html#numpy.argsort)

### Task C

Preprocess and store the list of top three similar users for each user
(try to come up with some simple definition of similarity based on the
text in the posts). Again show this information on the user page.

**Bonus:** Try to use some simple topic modeling (e.g. PCA as in
TruncatedSVD from scikit-learn) and use it for finding similar users.

