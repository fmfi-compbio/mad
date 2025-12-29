---
title: Ljavascript
---

* TOC
{:toc}

[HWjavascript](./HWjavascript.md)

In this lecture we will extend the website from the previous lecture
with interactive visualizations written in JavaScript. We will not cover
details of the JavaScript programming language, only use visualization
contained in the Google Charts library.

Your goal is to take examples from [the
documentation](https://developers.google.com/chart/interactive/docs/)
and tweak them for your purposes.

## Overview of the approach

  - Your Python server (in Flask) produces a HTML page with some
    content.
  - You can embed some JavaScript code inside the HTML. This code will
    be run in a browser.

In this case we want JavaScript to visualize data which resides in an
SQLite3 database.

  - Examples in the documentation contain data written directly in the
    JavaScript code (such as `var data` in the
    [histogram](https://developers.google.com/chart/interactive/docs/gallery/histogram)
    example).
  - We will also use this simple way, but see the warning below.

So data flow can be as follows:

  - Web browser requests a webpage concerning a user.
  - Your Python code reads data concerning this user from the database
    and embeds it into the JavaScript portion of a Jinja template.
      - For this you can use jinja
        [for-loop](https://jinja.palletsprojects.com/en/2.11.x/templates/#for)
        (see also the simple example
        [below](./#A_simple_example.md)). Or you can produce a
        string in Python, which you will put into a HTML. You might need
        to [turn off
        autoescaping](https://stackoverflow.com/questions/3206344/passing-html-to-template-using-flask-jinja2)).
  - The resulting HTML file is sent to the web browser.
  - The web browser executes JavaScript code in the HTML file, which
    creates visualization of the data.

![Flow of data](Lflask.png "Flow of data")

**Warning:**

  - Writing data into JavaScript code is a (very) bad practice, but
    sufficient for this lecture. (A better way is to load data in JSON
    format through API).

## Tips

  - Documentation for each chart contains also HTML+JS code example.
    That is a good starting point. You can just put it inside the flask
    template and see what it does.
  - Debugging tip: When looking for errors, limit the amount of data you
    send through the template, so you can easily read the resulting JS
    code.
  - Debugging tip 2: Viewing page source code (via Ctrl+U), can show you
    what you sent to browser.
  - Debugging tip 3: If you open devtools (Ctrl+Shift+J in Chrome, F12
    in Firefox) and go to the Console tab, you can see individual
    Javacript errors.
  - Consult the [previous lecture](./Lflask.md) on running and
    accessing Flask applications.

## Using multiple charts in the same page (merging examples)

  - You need to include <tt>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js">
    </script>
    </tt> just once. This is similar to `import` in Python.
  - You can either load individual packages separately by commands of
    the form: `google.charts.load("current", {packages:["calendar"]});`
    or you can list all packages in one array of the `load` method.
  - After loading of library is done, you can call function named
    `drawChart` as follows:
    `google.charts.setOnLoadCallback(drawChart);`. You can either draw
    multiples charts in one function, or call multiple functions (you
    need to set multiple callbacks). Be careful to not name multiple
    functions with same name.
  - Each chart needs its own HTML element with different ID. It looks
    something like this: `<div id="chart_div" style="width: 900px;
    height: 500px;">`. The id `chart_div` is then referenced here: `new
    google.visualization.Histogram(document.getElementById('chart_div'));`
  - Follow the instructions here:
    [1](https://developers.google.com/chart/interactive/docs/basic_multiple_charts?hl=en)

## A simple example

Here is a very simple HTML page with JavaScript where JavaScript adds
all items from array `fruits` as paragraphs to the page (without running
JavaScript the page would appear empty). The list of fruits is here a
simple example of "data" to be displayed. Instead you will use data
about a particular user.

    <!doctype html>
    <html>
    <head>
      <title>Fruits</title>
    </head>
    <body>
    </body>
    <script type="text/javascript">
      // an array of fruits (example data)
      fruits = ["apple", "pear", "banana"]
      // call a function which will add the name of each fruit
      // to a separate paragraph
      add_paragraphs(fruits)
         
      function add_paragraphs(items) {
        // get a list of items and add each as a paragraph
        for (item of items) {
          newPar = document.createElement('p');
          newPar.textContent = item;
          document.body.appendChild(newPar);
        }
      }
    </script>
    </html>

Instead of having a hard-coded "data" (list of fruits) directly in the
HTML file, we may want to insert them by Python (flask application),
e.g. from a database. The Python script below obtains data (here a
constant, in practice by SQL query) and passes it to Jinja template
`templates/main.html`.

    from flask import Flask, render_template, g
    import sqlite3
    
    app = Flask(__name__)
    
    def connect_db():
        return sqlite3.connect('db.sqlite3')
    
    @app.before_request
    def before_request():
        g.db = connect_db()
    
    @app.teardown_request
    def teardown_request(exception):
        db = getattr(g, 'db', None)
        if db is not None:
            db.close()
    
    @app.route('/')
    def home():
        fruits = ["apple", "pear", "banana"]  // replace by SQL query
        return render_template('main.html', fruits=fruits)

The Jinja template `templates/main.html` uses a for-loop to insert items
from the list, each enclosed in quotes and followed by comma. Otherwise
the rest of the page is as above.

    <!doctype html>
    <html>
    <head>
      <title>Fruits</title>
    </head>
    <body>
      <div id="main">
      </div>
      <script type="text/javascript">
        // an array of fruits (example data)
        fruits = [
        {% for fruit in fruits %}
           "{{ fruit }}",
        {% endfor %}
        ]
        // call a function which will add the name of each fruit
        // to a separate paragraph
        add_paragraphs(fruits)
    
        function add_paragraphs(items) {
          // get a list of items and add each as a paragraph
          for (item of items) {
            newPar = document.createElement('p');
            newPar.textContent = item;
            document.getElementById('main').appendChild(newPar);
          }
        }
      </script>
    </body>
    </html>

