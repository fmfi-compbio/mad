---
title: Lr1
---

* TOC
{:toc}

[HWr1](./HWr1.md)  [Video introduction from an older edition of
the course](https://youtu.be/qHdtopqSiXA)

Program for this lecture: basics of R

  - A very short introduction will be given as a lecture.
  - Exercises have the form of a tutorial: read a bit of text, try some
    commands, extend/modify them as requested in individual tasks

In this course we cover several languages popular for scripting and data
processing: Perl, Python, R.

  - Their capabilities overlap, many extensions emulate strengths of one
    in another.
  - Choose a language based on your preference, level of knowledge,
    existing code for the task, the rest of the team.
  - Quickly learn a new language if needed.
  - Also possibly combine, e.g. preprocess data in Perl or Python, then
    run statistical analyses in R, automate the entire pipeline with
    `bash` or `make`.

## Introduction

  - [R](http://www.r-project.org/) is an open-source system for
    statistical computing and data visualization.
  - Programming language, command-line interface
  - Many built-in functions, additional libraries
      - For example [Bioconductor](http://bioconductor.org/) for
        bioinformatics
  - We will concentrate on useful commands rather than language
    features.

## Working in R

**Option 1:** Run command R, type commands in a command-line interface

  - It supports history of commands (arrows, up and down, Ctrl-R) and
    completing command names with the tab key

**Option 2:** Write a script to a file, run it from the command-line as
follows:  
`R --vanilla --slave < file.R`

**Option 3:** Use `rstudio` command to open a [graphical
IDE](https://www.rstudio.com/products/RStudio/)

  - Sub-windows with editor of R scripts, console, variables, plots.
  - Ctrl-Enter in editor executes the current command in console.
  - You can also install RStudio on your home computer and work there.

**Option 4:** If you like Jupyter notebooks, you can use them also to
run R code, see for example an explanation of how to enable it in Google
Colab
[1](https://towardsdatascience.com/how-to-use-r-in-google-colab-b6e02d736497).

In R, you can easily create **plots**. In command-line interface these
open as a separate window, in Rstudio they open in one of the
sub-windows.

``` r
x = c(1:10)
plot(x, x * x)
```

**Suggested workflow**

  - Work interactively in Rstudio, notebook or on command line, try
    various options.
  - Select useful commands, store in a script.
  - Run the script automatically on new data/new versions, potentially
    as a part of a bigger pipeline.

## Additional information

  - [Official
    tutorial](http://cran.r-project.org/doc/manuals/R-intro.html)
  - [Seefeld, Linder: Statistics Using R with Biological Examples (pdf
    book)](http://cran.r-project.org/doc/contrib/Seefeld_StatsRBio.pdf)
  - [Patrick Burns: The R
    Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf)
    (intricacies of the language)
  - [Other books](https://www.r-project.org/doc/bib/R-books.html)
  - Built-in help: `? plot` displays help for `plot` command

## Gene expression data

  - DNA molecules contain regions called genes, which "recipes" for
    making proteins.
  - Gene expression is the process of creating a protein according to
    the "recipe".
  - It works in two stages: first a gene is copied (transcribed) from
    DNA to RNA, then translated from RNA to protein.
  - Different proteins are created in different quantities and their
    amount depends on the needs of a cell.
  - There are several technologies (microarray, RNA-seq) for measuring
    the amount of RNA for individual genes, this gives us some measure
    how active each gene is under given circumstances.

Gene expression data is typically a table with numeric values.

  - Rows represent genes.
  - Columns represent experiments (e.g. different conditions or
    different individuals).
  - Each value is the expression of a gene, i.e. the relative amount of
    mRNA for one gene in one experiment.

We will use a data set for yeast:

  - Abbott, Derek A., et al. "[Generic and specific transcriptional
    responses to different weak organic acids in anaerobic chemostat
    cultures of Saccharomyces
    cerevisiae.](https://academic.oup.com/femsyr/article/7/6/819/533265)"
    FEMS yeast research 7.6 (2007): 819-833.
  - Downloaded from the [GEO
    database](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE5926)
  - Data was preprocessed: normalized, converted to logarithmic scale.
  - Only 1220 genes with the biggest changes in expression are included
    in our dataset.
  - The dataset contains gene expression measurements under 5
    conditions:
      - Control: yeast grown in a normal environment.
      - 4 different acids added so that cells grow 50% slower (acetic,
        propionic, sorbic, benzoic).
  - From each condition (reference and each acid) we have 3 replicates,
    together 15 experiments.
  - The goal is to observe how the acids influence the yeast and the
    activity of its genes.

Part of the file (only the first 4 experiments and first 3 genes shown),
strings `2mic_D_protein, AAC3, AAD15` are identifiers of genes.

    ,control1,control2,control3,acetate1,acetate2,acetate3,...
    2mic_D_protein,1.33613934199651,1.13348900359964,1.2726678684356,1.42903234691804,...
    AAC3,0.558482767397578,0.608410781454015,0.6663002997292,0.231622581964063,...
    AAD15,-0.927871996497105,-1.04072379902481,-1.01885986692013,-2.62459941525552,...

