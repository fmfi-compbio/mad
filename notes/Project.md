---
title: Project
---

* TOC
{:toc}

The goal of the project is to apply and extend the skills acquired
during the course while working on a data analysis project of your
choice. Your task is to obtain data, analyze it and display the obtained
results in clear graphs and tables. It is ideal if you obtain
interesting or useful conclusions, but we will mainly evaluate your
choice of suitable methods and technical difficulty of the project. The
scope of programming or data analysis should correspond to roughly three
homework assignments, but overall the project will be more demanding,
because unlike assignments, you are not provided with data and a
sequence of tasks, but you have to come up with them yourself, and the
first ideas do not always work. You will also have to document your work
in a written report.

The emphasis should be on tools run on the command line and the use of
technologies covered during the course, but if needed, you can
supplement them by other methods. While prototyping your tool and
creating visualizations for your final report, you may prefer to work in
interactive environments such as the Jupyter notebook, but in the
submitted version of the project, most of the code should be in scripts
runnable from the command line, potentially excluding the final
visualization, which can remain as a notebook or an interactive website
(flask).

Project can be done by **pairs of students**, however the project should
be then bigger. Each student should be primarily responsible for some
parts of the project and the division of labor should be listed in the
project report. Pairs submit only one project, but the oral exam is
separate for each student.

## Project proposal

In roughly two thirds of the semester, you will submit a project
proposal with length of about half a page. In this proposal, state what
data you will process, how you will collect it, what the purpose of the
analysis is and what technologies you plan to use. You can slightly
change the goals and technologies as you work on the project, but you
should have an initial idea. We will give you feedback on the proposal,
and in some cases it may be necessary to change the topic slightly or
completely. For a suitable project proposal submitted on time, you will
receive 5% of the total grade. We recommend consulting the instructors
before submitting the proposal.

**How to submit the proposal:** copy a file in txt alebo pdf format to
</tt>/submit/proposal/username</tt> on the course server.

## Typical scheme of a project

Most projects consist of the following stages which should also be
represented in the report

  - **Acquiring data.** This can be easy if someone gives you the data
    or if you download it from internet as a single file. It can also be
    more difficult if you need to parse the data from many data files or
    webpages. Do not forget to check if the data was downloaded
    correctly (at least by manually checking several records). The
    project report (in combination with protocol) should clearly
    indicate where and how you obtained the data.
  - **Preprocessing data to a suitable form.** This stage involves
    parsing input formats, selecting useful data, checking them for
    correctness, filtering incomplete records etc. Store your data set
    in a file or database suitable for further processing. Do not forget
    to check if data seems to be correct. In the report, include basic
    characteristics of the data such as the overall number of records,
    attributes of each record and value ranges for these attributes etc.
    This will help the reader to understand the character of your data
    set.
  - **Further analyses and data visualization.** At this stage try to
    arrive at interesting or useful conclusions. The results can be
    static figures and tables or an interactive webpage in flask.
    However, even for an interactive webpage include selected results in
    the report as static images.

If your project significantly differs from this scheme, consult the
instructors.

## Project topics

  - You can process some data useful for your bachelor or master thesis
    or data necessary for another course (in that case mention in the
    report which course it is and also notify the instructors of the
    other course that you have used results from this course). For DAV
    and BIN students, this project can be a good opportunity to select a
    topic of the bachelor thesis and start working on it.
  - You can try to find someone who needs to process some data set but
    does not have the necessary skills (this could be scientists from
    different fields, non-profit organizations or even companies). If
    you contact third parties in this way, it is especially important
    that you try to produce the best project you can, in order to
    maintain the good reputation of your study program.
  - In your project, you can compare speed or accuracy of several
    programs for the same task. The project will consist of preparing
    the input data for the programs, support for automated running of
    the programs and evaluation of results.
  - You can also try to replicate an analysis published in a scientific
    paper or a blog. You can check if you obtain the same results as the
    original authors and try variations of the original analysis, such
    as trying different parameters, changing settings, adding new
    visualizations etc.
  - You can also find interesting data on the internet and analyze them.
    Students often choose topics related to their hobbies and
    activities, such as sports, computer games, programming contests,
    music, cooking etc. Many successful projects involve scrapping such
    data from some websites.

**Not recommended:**

  - We do not recommend choosing a dataset from Kaggle or a similar
    site.
  - Many of these datasets are dubious, submitted by anonymous users
    without a good explanation of where the data came from. If you do
    use a dataset from Kaggle, make sure you research its background
    thoroughly so that you can convince us that it is trustworthy.
  - Another problem is that these datasets are usually already
    preprocessed. Thus work related to this course is mostly done and it
    is hard to find suitable tasks for the project.
  - Finally, many of these datasets already have many analyses done and
    published, so why add more to an already large pile?

## Use of AI code generation

  - Some editors provide options for automated code generation based on
    context or comments.
  - On the project, you are allowed to use such tools (but not on the
    homework).
  - If you use such features, make sure you closely examine any
    generated code and correct any mistakes. You should understand how
    the code works and test it thoroughly. On the oral exam, we will
    check if you can explain how your code works and to modify it.
  - Acknowledge any such tools used in the resources section of your
    protocol.

## Submitting projects

Similarly as for homeworks, submit the required files to the specified
folder. Submit the following:

  - Your **programs and data files** (do not submit large data above
    50Mb or sensitive data such as personal information)
  - **Protocol** in txt format with brief notes similarly as for
    homeworks. If should contain
      - a list of submitted files with brief descriptions
      - detailed steps done in data analysis (commands used)
      - explanation how your script can be run by somebody else (if
        relevant), including steps for installing any non-standard
        libraries used
      - list of resources used (data, programs, documentation and other
        literature etc.)
  - **Project report** in pdf format. Unlike the less formal protocol,
    the report should be a coherent text written in a technical style.
    You can write in English or Slovak, but avoid grammar mistakes. The
    report should contain the following information:
      - an introduction explaining goals of the project and necessary
        background from the area you work in,
      - a description of your data, including where and how it was
        obtained and what it contains,
      - a brief method description which does not contain details of
        individual steps but rather overview of the method and its
        justification,
      - results of your analysis (tables, graphs etc.), description of
        these results and discussion about conclusions that can be made
        from your results,
      - a conclusion where you discuss which parts of the project were
        difficult and what problems you have encountered, which parts
        you have in contrast were able to do easily, which parts you
        would recommend in retrospect to do differently, what you have
        learned during the project etc.
      - Additional recommendations for the report:
          - Do not forget to explain the meaning of individual tables
            and graphs (axes, colors etc.).
          - Include the final results as well initial exploration of
            your data and analyses that you have used to verify
            correctness of the data and your analysis method.
          - You can interleave results and methods or keep them
            separate.

