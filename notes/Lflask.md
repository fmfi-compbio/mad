---
title: Lflask
---

* TOC
{:toc}

[HWflask](./HWflask.md)

In this lecture, we will use Python to process user comments obtained in
the previous lecture.

  - We will display information about individual users as a dynamic
    website written in Flask framework.
  - We will use simple text processing utilities from ScikitLearn
    library to extract word use statistics from the comments.

## Flask

[Flask](http://flask.pocoo.org/docs/1.0/quickstart/) is a simple web
server for Python. Using Flask you can write a simple dynamic website in
Python.

### Running Flask

You can find a sample Flask application at `/tasks/flask/simple_flask.`
Beware, the database included in this folder is just an empty one. You
need to either copy in your db from previous exercise or use one from
directory above.

You can run the example Flask app using these commands:

``` bash
cd <your directory>
export FLASK_APP=main.py
# this is optional, but recommended for debugging
# If you are running flask on your own machine you might want to use add `--debug` flag in the `flask run` command
# instead of the FLASK_ENV environment variable.
export FLASK_ENV=development 

# before running the following, change the port number
# so that no two users use the same number
flask run --port=PORT 
```

PORT is a random number greater than 1024. This number should be
different from other people running flask on the same machine (if you
run into the problem where flask writes out lot of error messages
complaining about permissions, select a different port number). Flask
starts a webserver on port PORT and serves the pages created in your
Flask application. Keep it running while you need to access these pages.

To view these pages, open a web browser on the same computer where the
Flask is running, e.g. ` chromium-browser  `<http://localhost:PORT/>
(use the port number you have selected to run Flask).

However, if you are running flask on a server, you probably want to run
the web browser on your local machine. In such case, you need to use
**ssh tunnel** to channel the traffic through ssh connection:

  - On your local machine, open another console window and create an ssh
    tunnel as follows: `ssh -L PORT:localhost:PORT
    username@vyuka.compbio.fmph.uniba.sk` (replace PORT with the port
    number you have selected to run Flask)
  - For Windows machines, -L option works out of box in Ubuntu subsystem
    for Windows or Powershell ssh, see [Connecting to
    server](./Connecting_to_server.md).
  - (STRONGLY NOT RECOMMENDED, USE POWERSHELL INSTEAD) If you use Putty
    on Windows, follow a
    [tutorial](https://blog.devolutions.net/2017/04/how-to-configure-an-ssh-tunnel-on-putty)
    how to create an ssh tunnel. Destination should be localhost:PORT,
    source port should be PORT. Do not forget to click add.
  - Keep this ssh connection open while you need to access your Flask
    web pages; it makes port PORT available on your local machine
  - In your browser, you can now access your Flask webpages, using e.g.
    ` chromium-browser  `<http://localhost:PORT/>

### Structure of a Flask application

  - The provided Flask application resides in the `main.py` script.
  - Some functions in this script are annotated with decorators starting
    with `@app`.
  - Decorator `@app.before_request` marks a function which will be
    executed before processing a particular request from a web browser.
    In this case we open a database connection and store it in a special
    variable `g` which can be used to store variables for a particular
    request. (Sidenote: Opening the connection before every request is
    quite bad practice. Also using sqlite3 for web applications is not
    ideal because it does not have advanced access control. If you want
    to build a serious web app you should use PostgreSQL and something
    like SQLAlchemy for handling connections. We are simplifying stuff
    here for educational purposes). If you open db connection using any
    other way than through `g.db`, e.g. as a normal global variable, you
    may get various unpleasant errors.
  - Decorator `@app.route('/')` marks a function which will serve the
    main page of the application with URL <http://localhost:4247/>.
    Similarly decorator `@app.route('/wat/`<random_id>`/')` marks a
    function which will serve URLs of the form
    <http://localhost:4247/wat/100> where the particular string which
    the user uses in the URL (here `100`) will be stored in `random_id`
    variable accessible within the function.
  - Functions serving a request return a string containing the requested
    webpage (typically a HTML document). For example, function `wat`
    returns a simple string without any HTML markup.
  - To more easily construct a full HTML document, you can use
    [jinja2](https://jinja.palletsprojects.com/en/3.1.x/) templating
    language, as is done in the `home` function. The template itself is
    in file `templates/main.html`. You may want to construct different
    templates for different webpages (e.g. main menu, user page).
  - To fill in variables in the template we use `{{ ... }}` notation.
    There are also `{% for x in something %}` statemens and `{% if ...
    %}` statements.
  - To get the url of some other page you can use `url_for` (see the
    provided template).

## Processing text

The main tool we will use for processing text is
[`CountVectorizer`](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html)
class from the Scikit-learn library. It transforms a text into a bag of
words representation. In this representation we get the list of words
and the count for each word. Example:

``` Python
from sklearn.feature_extraction.text import CountVectorizer

vec = CountVectorizer(strip_accents='unicode')

texts = [
 "Ema ma mamu.",
 "Zirafa sa vo vani kupe a hneva sa."
]

t = vec.fit_transform(texts).toarray()

print(t)
# prints:
# [[1 0 0 1 1 0 0 0 0]
#  [0 1 1 0 0 2 1 1 1]]

print(vec.vocabulary_)
# prints:
# {'vani': 6, 'ema': 0, 'kupe': 2, 'mamu': 4, 
# 'hneva': 1, 'sa': 5, 'ma': 3, 'vo': 7, 'zirafa': 8}
```

## NumPy arrays

Array `t` in the example above is a NumPy array provided by the [NumPy
library](https://numpy.org/). This library has also lots of nice tricks.
First let us create two matrices:

    >>> import numpy as np
    >>> a = np.array([[1,2,3],[4,5,6]])
    >>> b = np.array([[7,8],[9,10],[11,12]])
    >>> a
    array([[1, 2, 3],
           [4, 5, 6]])
    >>> b
    array([[ 7,  8],
           [ 9, 10],
           [11, 12]])

We can sum these matrices or multiply them by some number:

    >>> 3 * a
    array([[ 3,  6,  9],
           [12, 15, 18]])
    >>> a + 3 * a
    array([[ 4,  8, 12],
           [16, 20, 24]])

We can calculate sum of elements in each matrix, or sum by some axis:

    >>> np.sum(a)
    21
    >>> np.sum(a, axis=1)
    array([ 6, 15])
    >>> np.sum(a, axis=0)
    array([5, 7, 9])

There are many other useful functions, check [the
documentation](https://docs.scipy.org/doc/numpy-dev/user/quickstart.html).

## Other useful frameworks (for general interest, not for this lecture)

  - [FastAPI](https://fastapi.tiangolo.com/) is sort of similar to Flask
    but more focused on making API (not webpages).
  - [Django](https://www.djangoproject.com/) is big web framework with
    all belts and whistles (e.g. database support, i18n, ...).
  - [Dash](https://dash.plotly.com/) is another fully featured (read
    bloated) web framework for creating analytics pages (has extensive
    support, for graphs, tables, ...).

