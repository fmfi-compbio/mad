---
title: Python
---

* TOC
{:toc}

This page contains a brief Python tutorial for students who are not very
familiar with the language.

Python is a very popular programming language.

  - Advantages: powerful language features, extensive libraries
  - Disadvantages: interpreted language, can be slow

Other resources:

  - [A very concise cheat
    sheet](https://perso.limsi.fr/pointal/_media/python:cours:mementopython3-english.pdf)
  - [A more detailed tutorial](https://docs.python.org/3/tutorial/)

We will illustrate basic features of Python on several scripts working
with files `series.csv` and `episodes.csv` introduced in the [lecture in
SQL](./Lsql.md).

  - In the first two examples we just use standard Python functions for
    reading files and split lines into columns by `split` command.
  - This does not work well for `episodes.csv` file where comma
    sometimes separates columns and sometimes is in quotes within a
    column. Therefore we use [csv
    module](https://docs.python.org/3/library/csv.html), which is one
    the the standard Python modules.
  - Alternatively, one could import CSV files via more complex
    libraries, such as [Pandas](https://pandas.pydata.org/).
  - In [lecture on SQL](./Lsql.md), similar tasks as these scripts
    are done by very short SQL commands. In Pandas we could also achieve
    similar results using a few commands.
  - All scripts are provided in `/tasks/sql/` folder. Run them using
    `python3` interpreter, e.g.

<!-- end list -->

``` bash
# create folder for this homework
mkdir sql 
cd sql
# copy files to this folder
cp -iv /tasks/sql/* .
# run the first program (it will read file series.csv)
python3 prog1.py
```

### prog1.py

The first script prints the second column (series title) from
`series.csv`

``` Python
# open a file for reading
with open('series.csv') as csvfile:
    # iterate over lines of the input file
    for line in csvfile:
        # split a line into columns at commas
        columns = line.split(",")
        # print the second column
        print(columns[1])
```

  - Python uses indentation to delimit blocks. In this example, the
    `with` command starts a block and within this block the `for`
    command starts another block containing commands `columns=...` and
    `print`. The body of each block is indented several spaces relative
    to the enclosing block.
  - Variables are not declared, but directly used. This program uses
    variables `csvfile, line, columns`.
  - The `open` command opens a file (here for reading, but other options
    are
    [available](https://docs.python.org/3/library/functions.html#open)).
  - The [`with`
    command](https://www.geeksforgeeks.org/with-statement-in-python/)
    opens the file, stores the file handle in `csvfile` variable,
    executes all commands within its block and finally closes the file.
  - The for-loop iterates over all lines in the file, assigning each in
    variable `line` and executing the body of the block.
  - Method `split` of the built-in string type `str` splits the line at
    every comma and returns a list of strings, one for every column of
    the table (see also other [string
    methods](https://docs.python.org/3/library/stdtypes.html#string-methods))
  - The final line prints the second column and the end of line
    character.

### prog2.py

The following script prints the list of series of each TV channel.

  - For illustration we also separately count the number of the series
    for each channel, but the count could be also obtained as the length
    of the list.

<!-- end list -->

``` Python
from collections import defaultdict

# Create a dictionary in which default value
# for non-existent key is 0 (type int)
# For each channel we will count the series
channel_counts = defaultdict(int)

# Create a dictionary for keeping a list of series per channel
# default value empty list
channel_lists = defaultdict(list)

# open a file and iterate over lines
with open('series.csv') as csvfile:
    for line in csvfile:
        # strip whitespace (e.g. end of line) from end of line
        line = line.rstrip()
        # split line into columns, find channel and series names
        columns = line.split(",")
        channel = columns[2]
        series = columns[1]
        # increase counter for channel
        channel_counts[channel] += 1
        # add series to list for the channel
        channel_lists[channel].append(series)

# print counts
print("Counts:")
for (channel, count) in channel_counts.items():
    print(f"Channel \"{channel}\" has {count} series.")

# print series lists
print("\nLists:")
for channel in channel_lists:
    list = ", ".join(channel_lists[channel]) 
    print("Series for channel \"%s\": %s" % (channel,list))
```

  - In this script, we use two dictionaries (maps, associative arrays),
    both having channel names as keys. Dictionary `channel_counts`
    stores the number of series, `channel_lists` stores the list of
    series names.
  - For simplicity we use a library data structure called `defaultdict`
    instead of a plain python dictionary. The reason is easier
    initialization: keys do not need to be explicitly inserted to the
    dictionary, but are initialized with a default value at the first
    access.
  - Reading of the input file is similar to the previous script.
  - Afterwards we iterate through the keys of both dictionaries and
    print both the keys and the values.
  - We format the output string using f-strings `f"..."` where
    expressions in `{ }` are evaluated and substituted to the string.
    Formatting similar to C-style `printf`, e.g. `print(f"{2/3:.3f}").`
  - Notice that when we print counts, we iterate through pairs
    `(channel, count)` returned by `channel_counts.items()`, while when
    we print series, we iterate through keys of the dictionary.

### prog3.py

This script finds the episode with the highest number of votes among all
episodes.

  - We use a library for csv parsing to deal with quotation marks around
    episode names with commas, such as `"Dark Wings, Dark Words"`.
  - This is done by first opening a file and then passing it as an
    argument to `csv.reader`, which returns a reader object used to
    iterate over rows.

<!-- end list -->

``` Python
import csv

# keep maximum number of votes and its episode
max_votes = 0
max_votes_episode = None

# open a file
with open('episodes.csv') as csvfile:
    # create a reader for parsing csv files
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    # iterate over rows already split into columns
    for row in reader:
        votes = int(row[6])
        if votes > max_votes:
            max_votes = votes
            max_votes_episode = row[1]
        
# print result
print(f"Maximum votes {max_votes} in episode \"{max_votes_episode}\"")
```

### prog4.py

The following script shows an example of function definition.

  - The function reads a whole csv file into a 2d array.
  - The rest of the program calls this function twice for each of the
    two files.
  - This could be followed by some further processing of these 2d
    arrays.

<!-- end list -->

``` Python
import csv

def read_csv_to_list(filename):
    # create empty list
    rows = []
    # open a file
    with open(filename) as csvfile:
        # create a reader for parsing csv files
        reader = csv.reader(csvfile, delimiter=',', quotechar='"')
        # iterate over rows already split into columns
        for row in reader:
            rows.append(row)
    return rows

series = read_csv_to_list('series.csv')
episodes = read_csv_to_list('episodes.csv')
print(f"The number of episodes is {len(episodes)}.")
# further processing of series and episodes...
```

### Command-line arguments

  - In data processing, it is better to write scripts which do not have
    filenames and other details written directly in the code but accept
    them as arguments from command line (similarly as various command
    line utilities, such as `sort`, `head` etc.).
  - You can then run the same script on different inputs or with
    different setttings.
  - In Python, this is usually achieved using
    [`argparse`](https://docs.python.org/3/library/argparse.html)
    library.
  - The script below accepts a filename, reads lines from this file and
    prints to standard output (screen).
  - It also accepts an optional argument `-l` followed by a number which
    will limit the number of printed lines (similarly as in `head -n`
    command).

<!-- end list -->

``` Python
import argparse

# create parser of arguments
parser = argparse.ArgumentParser(description='Example program for using command-line arguments')
# add one required argument giving the name of a file
parser.add_argument('filename', help='Name of a file to open')
# add an optional argument giving the number of lines to read
parser.add_argument('--limit', '-l', type=int, default=None, 
                    help='Number of lines to read (default all)')
# parse the arguments into args namespace
# they can be accessed as args.filename and args.limit
args = parser.parse_args()

# open file
with open(args.filename) as f:
    # iterate over lines in the file
    for (line_number, line) in enumerate(f):
        # end iteration if limit is reached
        if args.limit is not None and line_number >= args.limit:
            break
        # otherwise print the line
        print(line, end='')
```

This script is stored in `/tasks/python/argument_example.py`. To print
the first three lines of file `/tasks/python/series.csv`, we can run it
as follows:

``` Python
python3 /tasks/python/argument_example.py -l 3 /tasks/python/series.csv
# OR:
python3 /tasks/python/argument_example.py --limit=3 /tasks/python/series.csv
```

