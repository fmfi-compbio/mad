---
title: HWcpp
---

* TOC
{:toc}

See [the lecture](./Lcpp.md)

## Overview

We will be solving a problem where we are given a list of documents.
Each document consists of multiple words separated by space. We will
assign each document an ID 0,1,... in the order they appear on input. We
want to implement an indexing data structure that allows the following
operations:

  - Function `add_document` adds a document to the index and returns its
    ID (the next available ID). A document is a list of words (strings).
  - Function `search` finds all documents that contain a given word, and
    returns a list or a set of their IDs.
  - Function `multi_search` gets a list of words and finds all documents
    that contain all of the words (so each document has to contain all
    words from the query). It returns a list or a set of document IDs.

Note that this functionality could be a base for a very simple text
search engine. We could extend it with the option for storing and
printing whole documents containing given keywords of interest, but we
will not do this today.

We will use a structure called **inverted index** which is a dictionary
in which keys are the words from the documents. For each word, we keep a
list or a set of document IDs that contain it.

### Main program

You are given the main program `doc_finder.py` which is almost finished.
It requires three command-line arguments. The first is the name of the
implementation, which is one of ListIndexPython, ListIndexCpp,
SetIndexPython, SetIndexCpp. The second input is a file with documents,
one document per line. Words in the document are separated by spaces.
The third argument is a file with queries, one query per line. If the
line contains a single word, it is passed to `search`, otherwise to
`multi_search`. For each query, the program prints the IDs of the found
documents separated by spaces. If no documents were found, it prints a
dash.

Here is an example of tiny debugging inputs and outputs:

    ==> tiny_documents.txt <==
    this is document zero about frog
    this is document one about dog and it is longer
    
    ==> tiny_queries.txt <==
    dog
    cat
    is
    is frog
    dog frog
    cat frog
    is this
    
    ==> tiny_answers.txt <==
    1
    -
    0 1
    0
    -
    -
    0 1

### ListPythonIndex implementation

You are given one implementation of this data structure in file
`ListIndexPython.py` which is implemented purely as a Python class.

  - It contains a dictionary in which keys are the words. For each word
    it keeps a list of document IDs in the increasing order.
  - Function `search` simply returns the list from the dictionary.
  - Function `multi_search` uses `search` to return a list of IDs for
    each input word. It maintains an intersection of lists seen so far
    and computes pairwise intersection of the new list and previous
    intersection.
  - Intersection of two sorted lists of IDs is done by a procedure
    similar to merging two sorted lists in [Merge
    Sort](https://en.wikipedia.org/wiki/Merge_sort). One integer index
    is moved along each list so that we always move forward the one that
    points to a smaller value. If both indices point to the same value,
    we found an element from the intersection which is placed into the
    result. As soon as one index reaches the end of the list, we are
    finished.

### Files

Tiny debugging input and correct output:

  - `/tasks/cpp/tiny_documents.txt` a file with documents
  - `/tasks/cpp/tiny_queries.txt` a file with queries (both single and
    multi-word)
  - `/tasks/cpp/tiny_answers.txt` correct answers for the queries

Larger inputs:

  - `/tasks/cpp/documents.txt` a file with documents
  - `/tasks/cpp/queries.txt` a file with single-word queries
  - `/tasks/cpp/multiqueries.txt` a file with multi-word queries

Program in Python:

  - `/tasks/cpp/doc_finder.py`
  - `/tasks/cpp/ListIndexPython.py`

Makefile for compiling and testing:

  - `/tasks/cpp/Makefile`

Outline of the protocol

  - `/tasks/cpp/protocol.txt`

You can run the program as follows:

    # run the program on the tiny inputs
    python3 /tasks/cpp/doc_finder.py ListIndexPython /tasks/cpp/tiny_documents.txt /tasks/cpp/tiny_queries.txt > ListIndexPython.result
    # check whether the answer is correct
    diff ListIndexPython.result /tasks/cpp/tiny_answers.txt 

Instead you can use the `Makefile` and run

    make test

The output of the program will be in `ListIndexPython.result` and the
result of `diff` in `ListIndexPython.test` (which is also printed to the
screen)

## Task A

Reimplement the class from `ListIndexPython.py` in C++ and use it in
Python.

  - Store your class in file `ListIndexCpp.cc` and call the module also
    `ListIndexCpp`.
  - Uncomment the import and constructor call for your class in
    `doc_finder.py`
  - Use the same algorithm in C++ as in Python. We recommend using STL
    structures
    [unorderd\_map](https://en.cppreference.com/w/cpp/container/unordered_map)
    and [vector](https://en.cppreference.com/w/cpp/container/vector).
  - In Makefile uncomment `ListIndexCpp.test` as a prerequisite of the
    `test` rule.
  - Your implementation should successfully compile and run on the tiny
    inputs and produce correct output (empty diff) using the commands
    below:

<!-- end list -->

    # compile C++, this should produce no compiler errors
    make compile
    # run tests, this should report that the files are identical
    make tests

  - **Submit** files `Makefile`, `doc_finder.py` and `ListIndexCpp.cc`.
    (You will modify the first two of these files also in task B.)

## Task B

Create another implementation of the data structure in both Python and
C++, in which you use sets instead of lists of document IDs for each
word.

  - In terms of functionality, the methods `search` and `multi_search`
    return sets, not lists. As a result, the document IDs are not
    necessarily ordered on output. Makefile contains a sorting step
    before comparing with the correct answer.
  - Also, the `ListIndexPython` checks in the `add_document` method that
    document IDs are increasing. This check would be costly here, do not
    perform it.
  - In Python, use set intersection instead of manual merge algorithm in
    `multi_search`. In C++ use
    [unordered\_set](https://en.cppreference.com/w/cpp/container/unordered_set),
    but this class does not provide explicit intersection method, so you
    need to test each element of one set whether it is located in the
    other set.
  - Store your implementations in `SetIndexPython.py` and
    `SetIndexCpp.cc`.
  - Add your new modules to the `doc_finder.py` (imports and constructor
    calls).
  - Also add support of your new modules to `compile` and `test` targets
    of the `Makefile` (only these two lines need to be modified). The
    `compile` target compiles only C++ code.
  - After these modifications, you should be able to compile and test
    all modules using the same commands as in part A.

<!-- end list -->

  - **Submit** files `Makefile`, `doc_finder.py`, `SetIndexPython.py`,
    `SetIndexCpp.cc`. When you are done with task B, your `Makefile` and
    `doc_finder.py` should support all four implementations of the
    index.

## Task C

  - Compare the running time and memory required by all four
    implementations (or those you successfully implemented).
  - Use the provided list of documents `/tasks/cpp/documents.txt` and
    consider three files with queries:
      - Empty file zero queries to measure how long it takes to build
        the index
      - `/tasks/cpp/queries.txt` to measure the speed of `search`
      - `/tasks/cpp/multiqueries.txt` to measure the speed of
        `multi-search`
  - Use /usr/bin/time as described in the lecture.
  - Run each implementation several times (at least 3x) on each input to
    see how the time and memory fluctuate.
  - Report the results in the protocol (in some easy-to-read form).
    Consider computing summary statics such as mean and standard
    deviation. Optionally you can show the results in a plot or a table
    placed in a png or pdf file.
  - Also discuss your observations and conclusions from the measured
    values in the protocol. How do the implementations compare to each
    other on different tasks?

Notes:

  - It might be a good idea to write some script for running programs,
    parsing the time and memory values and creating final table or plot.
    If you do so, submit your script as well. You can instead add new
    rules to the `Makefile` for this purpose.
  - You can run the experiments on your computer or on vyuka. If you run
    on vyuka, make sure the server is not too busy (you should get a
    high % of CPU, close to 100%).
  - Do not store outputs of these runs on vyuka. Remove them when not
    needed, as they are large files. However, it is a good idea to check
    if the outputs of the two `ListIndex` implementations are the same.
    The size of the output files for `SetIndex` implementations should
    be exactly the same as for `ListIndex`, but the order of IDs on each
    line may differ.

**Submit** the protocol, and any scripts or images you created.

