---
title: Introduction
---

* TOC
{:toc}

## Target audience

This course is offered at the Faculty of Mathematics, Physics and
Informatics, Comenius University in Bratislava for the students of the
second year of the bachelor Data Science and Bioinformatics study
programs and the students of the bachelor and master Computer Science
study programs. It is a prerequisite of the master-level state exam in
Bioinformatics and Machine Learning.

However, the course is open to students from other study programs if
they satisfy the following **informal prerequisites**.

  - Students should be proficient in **programming** in at least one
    programming language and not afraid to learn new languages.
  - Students should have basic knowledge of work on the Linux
    **command-line** (at least basic commands for working with files and
    folders, such as cd, mkdir, cp, mv, rm, chmod). If you do not have
    these skills, please study our
    [tutorial](./Command-line_basics.md) before the second
    lecture. The first week contains detailed instructions to get you
    started.

Although most technologies covered in this course can be used for
processing data from many application areas, we will illustrate some of
them on examples from bioinformatics. We will explain necessary
terminology from biology as needed.

## Course objectives

### Quick summary

  - Learn different languages and technologies for data processing
    tasks:
      - obtaining data,
      - preprocessing it to suitable form,
      - connecting existing tools into pipelines,
      - performing statistical tests and data visualization.
  - More details on statistical methods, visualization and machine
    learning are in different courses.
  - These tasks are fundamental in data science and bioinformatics, but
    also useful in many areas of computer science, where experimental
    evaluation and comparison of methods is needed.
  - Rather than learning one set of tools in detail, we give overview of
    many different ones.
  - Main reason is improving your flexibility so that you can quickly
    learn new language or library in future.

### More details

Computer science courses cover many interesting algorithms, models and
methods that can used for data analysis. However, when you want to use
these methods for real data, you will typically need to make
considerable efforts to obtain the data, pre-process it into a suitable
form, test and compare different methods or settings, and arrange the
final results in informative tables and graphs. Often, these activities
need to be repeated for different inputs, different settings, and so on.
Many jobs in data science and bioinformatics involve data processing
using existing tools and small custom scripts. This course will cover
some programming languages and technologies suitable for such
activities.

This course is also recommended for students whose bachelor or master
theses involve substantial empirical experiments (e.g. experimental
evaluation of your methods and comparison with other methods on real or
simulated data).

We do not aim to teach you in detail one specific language or
technology. Rather, we give you an overview of many different options,
often doing a different language each week. One of the goals is to
increase your flexibility so that you can quickly adapt when you need to
use something new.

## Basic guidelines for working with data

As you know, in programming it is recommended to adhere to certain
practices, such as good coding style, modular design, thorough testing
etc. Such practices add a little extra work, but are much more efficient
in the long run. Similar good practices exist for data analysis. As an
introduction we recommend the following article by a well-known
bioinformatician William Stafford Noble, but his advice applies outside
of bioinformatics as well.

  - Noble WS. [A quick guide to organizing computational biology
    projects.](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424)
    PLoS Comput Biol. 2009 Jul 31;5(7):e1000424.

Several important recommendations:

  - Noble 2009: **"Everything you do, you will probably have to do over
    again."**
      - After doing an entire analysis, you often find out that there
        was a problem with the input data or one of the early steps, and
        therefore everything needs to be redone.
      - Therefore it is better to use techniques that allow you to keep
        all details of your workflow and to repeat them if needed.
      - Try to avoid manually changing files, because this makes
        rerunning analyses harder and more error-prone.

<!-- end list -->

  - **Document all steps of your analysis**
      - Note what have you done, why have you done it, what was the
        result.
      - Some of these things may seem obvious to you at present, but you
        may forgot them in a few weeks or months and you may need them
        to write up your thesis or to repeat the analysis.
      - Good documentation is also indispensable for collaborative
        projects.

<!-- end list -->

  - **Keep a logical structure of your files and folders**
      - Their names should be indicative of the contents (create a
        sensible naming scheme).
      - However, if you have too many versions of the experiment, it may
        be easier to name them by date rather than create new long names
        (your notes should then detail the meaning of each dated
        version).

<!-- end list -->

  - **Try to detect problems in the data**
      - Big files often hide some problems in the format, unexpected
        values etc. These may confuse your programs and make the results
        meaningless.
      - In your scripts, check that the input data conform to your
        expectations (format, values in reasonable ranges etc).
      - In unexpected circumstances, scripts should terminate with an
        error message and a non-zero exit code.
      - If your script executes another program, check its exit code.
      - Also check intermediate results as often as possible (by manual
        inspection, computing various statistics etc) to detect errors
        in the data and your code.

