---
title: HWr2
---

* TOC
{:toc}

See also the [current](./Lr2.md) and the
[previous](./Lr1.md) lecture.

  - Do either tasks A,B,C (beginners) or B,C,D (more advanced). You can
    also do all four for bonus credit.
  - In your protocol write used R commands with brief comments on your
    approach.
  - Submit required plots with filenames as specified.
  - For each task also include results as required and a short
    discussion commenting the results/plots you have obtained. Is the
    value of interest increasing or decreasing with some parameter? Are
    the results as expected or surprising?
  - Outline of protocol is in `/tasks/r2/protocol.txt`

### Task A: sign test

  - Consider a situation in which players played *n* games, out of which
    a fraction of *q* were won by *A* (the example in the lecture
    corresponds to *q=0.6* and *n=10*).
  - Compute a table of p-values for combinations of *n=10,20,...,90,100*
    and *q=0.6, 0.7, 0.8, 0.9*.
  - Plot the table using `matplot` (*n* is x-axis, one line for each
    value of *q*).

<!-- end list -->

  - **Submit** the plot in `sign.png`.
  - **Discuss** the values you see in the plot / table.

Outline of the code:

``` r
# create vector rows with values 10,20,...,100
rows = (1:10) * 10
# create vector columns with required values of q
columns = c(0.6, 0.7, 0.8, 0.9)
# create empty matrix of pvalues 
pvalues = matrix(0, length(rows), length(columns))
# TODO: fill in matrix pvalues using binom.test

# set names of rows and columns
rownames(pvalues) = rows
colnames(pvalues) = columns
# careful: pvalues[10,] is now 10th row, i.e. value for n=100, 
#          pvalues["10",] is the first row, i.e. value for n=10

# check that for n=10 and q=0.6 you get p-value 0.3769531
pvalues["10","0.6"]

# create x-axis matrix (as in HWr1, part D)
x=matrix(rep(rows, length(columns)), nrow=length(rows))
# matplot command
png("sign.png")
matplot(x, pvalues, type="l", col=c(1:length(columns)), lty=1)
legend("topright", legend=columns, col=c(1:length(columns)), lty=1)
dev.off()
```

### Task B: Welch's t-test on microarray data

Run the code below which reads the microarray data and preprocesses them
(the last time we worked with preprocessed data). We first transform it
to log scale and then shift and scale values in each column so that
median is 0 and sum of squares of values is 1. This makes values more
comparable between experiments; in practice more elaborate normalization
is often performed. In the rest, work with table *a* containing
preprocessed data.

``` r
# read the input file
input = read.table("/tasks/r2/acids.tsv", header=TRUE, row.names=1)
# take logarithm of all the values in the table
input = log2(input)
# compute median of each column
med = apply(input, 2, median)
# shift and scale values
a = scale(input, center=med)
```

Columns 1,2,3 are control, columns 4,5,6 acetic acid, 7,8,9 benzoate,
10,11,12 propionate, and 13,14,15 sorbate.

Write a function `my.test` which will take as arguments table *a* and 2
lists of columns (e.g. 1:3 and 4:6) and will run for each row of the
table Welch's t-test of the first set of columns versus the second set.
It will return the resulting vector of p-values, one for each gene.

  - For example by calling `pb <- my.test(a, 1:3, 7:9)` we will compute
    p-values for differences between control and benzoate (computation
    may take some time)
  - The first 5 values of `pb` should be

<!-- end list -->

    > pb[1:5]
    [1] 0.02358974 0.05503082 0.15354833 0.68060345 0.04637482

  - Run the test for all four acids.
  - **Report** for each acid how many genes were significant with
    p-value at most 0.01.
      - See [Vector arithmetic in
        HWr1](./HWr1#Vector_arithmetic.md)
      - You can count `TRUE` items in a vector of booleans by `sum`,
        e.g. `sum(TRUE,FALSE,TRUE)` is 2.
  - **Report** also how many genes are significant for both acetic and
    benzoate acids simultaneously (logical "and" is written as `&`).

### Task C: multiple testing correction

Run the following snippet of code, which works on the vector of p-values
`pb` obtained for benzoate in task B.

``` r
# adjusts vectors of p-values from tasks B for using Bonferroni correction
pb.adjusted = p.adjust(pb, method ="bonferroni")
# add both p-value columns pb and pb.adjusted to frame a
a <-  cbind(a, pb, pb.adjusted)
# create permutation ordered by pb.adjusted
ob = order(pb.adjusted)
# select from table five rows with the lowest pb.adjusted (using vector ob)
# and display columns containing control, benzoate and both original and adjusted p-value
a[ob[1:5],c(1:3,7:9,16,17)]
```

You should get an output like this:

``` 
      control1  control2  control3  benzoate1  benzoate2  benzoate3
PTC4 0.5391444 0.5793445 0.5597744  0.2543546  0.2539317  0.2202997
GDH3 0.2480624 0.2373752 0.1911501 -0.3697303 -0.2982495 -0.3616723
AGA2 0.6735964 0.7860222 0.7222314  1.4807101  1.4885581  1.3976753
CWP2 1.4723713 1.4582596 1.3802390  2.3759288  2.2504247  2.2710695
LSP1 0.7668296 0.8336119 0.7643181  1.3295121  1.2744859  1.2986457
               pb pb.adjusted
PTC4 4.054985e-05   0.2594379
GDH3 5.967727e-05   0.3818152
AGA2 8.244790e-05   0.5275016
CWP2 1.041416e-04   0.6662979
LSP1 1.095217e-04   0.7007201
```

Do the same procedure for acetate p-values and **report** the result (in
your table, report both p-values and expression levels for acetate, not
bezoate). **Comment** on the results for both acids.

### Task D: volcano plot, test on data generated from null hypothesis

Draw a [volcano
plot](https://en.wikipedia.org/wiki/Volcano_plot_\(statistics\)) for the
acetate data.

  - The x-axis of this plot is the difference between the mean of
    control and the mean of acetate. You can compute row means of a
    matrix by `rowMeans`.
  - The y-axis is -log10 of the p-value (use the p-values before
    multiple testing correction).
  - You can quickly see the genes that have low p-values (high on
    y-axis) and also big difference in the mean expression between the
    two conditions (far from 0 on x-axis). You can also see if acetate
    increases or decreases the expression of these genes.

Now create a simulated dataset sharing some features of the real data
but observing the null hypothesis that the mean of control and acetate
are the same for each gene.

  - Compute vector *m* of means for columns 1:6 from matrix *a*
  - Compute vectors *sc* and *sa* of standard deviations for control
    columns and for acetate columns respectively. You can compute
    standard deviation for each row of a matrix by
    `apply(some.matrix, 1, sd)`.
  - For each i in 1:6398, create three samples from the normal
    distribution with mean `m[i]` and standard deviation `sc[i]` and
    three samples with mean `m[i]` and deviation `sa[i]` (use the
    `rnorm` function).
  - On the resulting matrix, apply Welch's t-test and draw the volcano
    plot.
  - How many random genes have p-value at most 0.01? Is it roughly what
    we would expect under the null hypothesis?

Draw a histogram of p-values from the real data (control vs acetate) and
from the random data (use function `hist`). **Describe** how they
differ. Is it what you would expect?

**Submit** plots `volcano-real.png`, `volcano-random.png`,
`hist-real.png`, `hist-random.png` (real for real expression data and
random for generated data).

