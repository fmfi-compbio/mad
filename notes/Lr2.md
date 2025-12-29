---
title: Lr2
---

* TOC
{:toc}

[HWr2](./HWr2.md)

The topic of this lecture are statistical tests in R.

  - Beginners in statistics: listen to lecture, then do tasks A, B, C
  - If you know basics of statistical tests, do tasks B, C, D
  - More information on this topic in the [1-EFM-340 Computer
    Statistics](https://sluzby.fmph.uniba.sk/infolist/sk/1-EFM-340.html)
    or [1-DAV-303 Statistical
    Methods](https://sluzby.fmph.uniba.sk/infolist/sk/1-DAV-303.html)
    courses.

## Introduction to statistical tests: sign test

  - Two friends *A* and *B* played their favorite game *n*=10 times, *A*
    won 6 times and *B* won 4 times.
  - *A* claims that she/he is a better player, *B* claims that such a
    result could easily happen by chance if they were equally good
    players.
  - Hypothesis of player *B* is called the *null hypothesis*. It claims
    that the pattern we see (*A* won more often than *B*) is simply a
    result of chance.
  - The null hypothesis reformulated: we toss coin *n* times and compute
    value *X*: the number of times we see head. The tosses are
    independent and each toss has equal probability of being head or
    tail.
  - Similar situation: comparing programs *A* and *B* on several inputs,
    and counting how many times is program *A* better than *B*.

<!-- end list -->

``` r
# simulation in R: generate 10 pseudorandom bits
# (1=player A won)
sample(c(0,1), 10, replace = TRUE)
# result e.g. 0 0 0 0 1 0 1 1 0 0

# directly compute random variable X, i.e. the sum of bits
sum(sample(c(0,1), 10, replace = TRUE))
# result e.g. 5

# we define a function which will m times repeat 
# the coin tossing experiment with n tosses 
# and returns a vector with m values of random variable X
experiment <- function(m, n) {
  x = rep(0, m)     # create vector with m zeroes
  for(i in 1:m) {   # for loop through m experiments
    x[i] = sum(sample(c(0,1), n, replace = TRUE)) 
  }
  return(x)         # return array of values     
}
# call the function for m=20 experiments, each with n=10 tosses
experiment(20,10)
# result e.g.  4 5 3 6 2 3 5 5 3 4 5 5 6 6 6 5 6 6 6 4
# draw histograms for 20 experiments and 1000 experiments
png("hist10.png")  # open png file
par(mfrow=c(2,1))  # matrix of plots with 2 rows and 1 column
hist(experiment(20,10))
hist(experiment(1000,10))
dev.off() # finish writing to file
```

  - It is easy to realize that we get [binomial
    distribution](https://en.wikipedia.org/wiki/Binomial_distribution)
    (binomické rozdelenie)
  - The probability of getting *k* ones out of *n* coin tosses is
    \(\Pr(X=k) = {n \choose k} 2^{-n}\)
  - The *p-value* of the test is the probability that simply by chance
    we would get *k* the same or more extreme than in our data.
  - In other words, what is the probability that in *n=10* tosses we see
    head 6 times or more (this is called one sided test).
  - P-value for *k* ones out of *n* coin tosses
    \(\sum_{j=k}^n {n \choose k} 2^{-n}\).
  - If the p-value is very small, say smaller than 0.01, we reject the
    null hypothesis and assume that player *A* is in fact better than
    *B*.

<!-- end list -->

``` r
# computing the probability that we get exactly 6 heads in 10 tosses
dbinom(6, 10, 0.5) # result 0.2050781
# we get the same as our formula above:
7*8*9*10/(2*3*4*(2^10)) # result 0.2050781

# entire probability distribution: probabilities 0..10 heads in 10 tosses
dbinom(0:10, 10, 0.5)
# [1] 0.0009765625 0.0097656250 0.0439453125 0.1171875000 0.2050781250
# [6] 0.2460937500 0.2050781250 0.1171875000 0.0439453125 0.0097656250
# [11] 0.0009765625

# we can also plot the distribution
plot(0:10, dbinom(0:10, 10, 0.5))
barplot(dbinom(0:10, 10, 0.5))

# our p-value is the sum for k=6,7,8,9,10
sum(dbinom(6:10, 10, 0.5))
# result: 0.3769531
# so results this "extreme" are not rare by chance,
# they happen in about 38% of cases

# R can compute the sum for us using pbinom 
# this considers all values greater than 5
pbinom(5, 10, 0.5, lower.tail=FALSE)
# result again 0.3769531

# if probability is too small, use log of it
pbinom(9999, 10000, 0.5, lower.tail=FALSE, log.p = TRUE)
# [1] -6931.472
# the probability of getting 10000x head is exp(-6931.472) = 2^{-100000}

# generating numbers from binomial distribution 
# - similarly to our function experiment
rbinom(20, 10, 0.5)
# [1] 4 4 8 2 6 6 3 5 5 5 5 6 6 2 7 6 4 6 6 5

# running the test
binom.test(6, 10, p = 0.5, alternative="greater")
#
#        Exact binomial test
#
# data:  6 and 10
# number of successes = 6, number of trials = 10, p-value = 0.377
# alternative hypothesis: true probability of success is greater than 0.5
# 95 percent confidence interval:
# 0.3035372 1.0000000
# sample estimates:
# probability of success
#                   0.6

# to only get p-value, run
binom.test(6, 10, p = 0.5, alternative="greater")$p.value
# result 0.3769531
```

## Comparing two sets of values: Welch's t-test

  - Let us now consider two sets of values drawn from two [normal
    distributions](https://en.wikipedia.org/wiki/Normal_distribution)
    with unknown means and variances.
  - The null hypothesis of the [Welch's
    t-test](https://en.wikipedia.org/wiki/Welch%27s_t-test) is that the
    two distributions have equal means.
  - The test computes test statistics (in R for vectors x1, x2):
      - `(mean(x1)-mean(x2))/sqrt(var(x1)/length(x1)+var(x2)/length(x2))`
  - If the null hypothesis holds, i.e. x1 and x2 were sampled from
    distributions with equal means, this test statistics is
    approximately distributed according to the [Student's
    t-distribution](https://en.wikipedia.org/wiki/Student%27s_t-distribution)
    with the degree of freedom obtained by

<!-- end list -->

``` r
n1=length(x1)
n2=length(x2)
(var(x1)/n1+var(x2)/n2)**2/(var(x1)**2/((n1-1)*n1*n1)+var(x2)**2/((n2-1)*n2*n2))
```

  - Luckily R will compute the test for us simply by calling `t.test`

<!-- end list -->

``` r
# generate x1: 6 values from normal distribution with mean 2 and standard deviation 1
x1 = rnorm(6, 2, 1)
# for example 2.70110750  3.45304366 -0.02696629  2.86020145  2.37496993  2.27073550

# generate x2: 4 values from normal distribution with mean 3 and standard deviation 0.5
x2 = rnorm(4, 3, 0.5)
# for example 3.258643 3.731206 2.868478 2.239788
t.test(x1, x2)
# t = -1.2898, df = 7.774, p-value = 0.2341
# alternative hypothesis: true difference in means is not equal to 0
# means 2.272182  3.024529
# this time the test was not significant

# regenerate x2 from a distribution with a much more different mean
x2 = rnorm(4, 5, 0.5)
# 4.882395 4.423485 4.646700 4.515626
t.test(x1, x2)
# t = -4.684, df = 5.405, p-value = 0.004435
# means 2.272182  4.617051
# this time much more significant p-value

# to get only p-value, run 
t.test(x1,x2)$p.value
```

We will apply Welch's t-test to microarray data

  - Data from the same paper as in [the previous
    lecture](./Lr1#Gene_expression_data.md), i.e. Abbott et al
    2007 [Generic and specific transcriptional responses to different
    weak organic acids in anaerobic chemostat cultures of *Saccharomyces
    cerevisiae*](http://femsyr.oxfordjournals.org/content/7/6/819.abstract)
  - Recall: Gene expression measurements under 5 conditions:
      - Control: yeast grown in a normal environment
      - 4 different acids added so that cells grow 50% slower (acetic,
        propionic, sorbic, benzoic)
  - From each condition (control and each acid) we have 3 replicates
  - Together our table has 15 columns (3 replicates from 5 conditions)
    and 6398 rows (genes). Last time we have used only a subset of rows.
  - We will test statistical difference between the control condition
    and one of the acids (3 numbers vs other 3 numbers).
  - See Task B in [the exercises](./HWr2.md).

## Multiple testing correction

  - When we run t-tests on the control vs. benzoate on all 6398 genes,
    we get 435 genes with p-value at most 0.01.
  - Purely by chance this would happen in 1% of cases (from the
    definition of the p-value).
  - So purely by chance we would expect to get about 64 genes with
    p-value at most 0.01.
  - So roughly 15% of our detected genes (maybe less, maybe more) are
    false positives which happened purely by chance.
  - Sometimes false positives may even overwhelm the results.
  - Multiple testing correction tries to limit the number of false
    positives among the results of multiple statistical tests. There are
    many different methods.
  - The simplest one is [Bonferroni
    correction](https://www.stat.berkeley.edu/~mgoldman/Section0402.pdf),
    where the threshold on the p-value is divided by the number of
    tested genes, so instead of 0.01 we use threshold 0.01/6398 =
    1.56e-6.
  - This way the expected overall number of false positives in the whole
    set is 0.01 and so the probability of getting even a single false
    positive is also at most 0.01 (by [Markov
    inequality](https://mathworld.wolfram.com/MarkovsInequality.html)).
  - We could instead multiply all p-values by the number of tests and
    apply the original threshold 0.01 - such artificially modified
    p-values are called adjusted or corrected. If we get a value greater
    than 1, we report p-value 1.
  - After the Bonferroni correction we do not get any significant gene.

<!-- end list -->

``` r
# the results of t-tests are in vector pb of length 6398
# manually multiply p-values by length(pb), count those that have value <= 0.01
sum(pb * length(pb) <= 0.01)
# in R you can use p.adjust for multiple testing correction
pb.adjusted = p.adjust(pb, method ="bonferroni")
# this is equivalent to multiplying by the length and using 1 if the result > 1
pb.adjusted = pmin(pb*length(pb), rep(1, length(pb)))

# there are less conservative multiple testing correction methods, 
# e.g. Holm's method, but in this case we get almost the same results
pb.adjusted2 = p.adjust(pb, method ="holm")
```

Another frequently used correction is false discovery rate (FDR), which
is less strict and controls the overall proportion of false positives
among the results.

