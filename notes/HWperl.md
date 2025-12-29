---
title: HWperl
---

* TOC
{:toc}

**Materials:** [the lecture](./Lperl.md), [Connecting to
server](./Connecting_to_server.md), [Editors](./Editors.md)

### Files and setup

We recommend creating a directory (folder) for this set of tasks:

``` bash
mkdir perl  # make directory
cd perl     # change to the new directory
```

The folder `/tasks/perl/` contains input files, an example script
working with FASTQ files and correct outputs for some of your scripts;
see further details below. In this first homework we will provide almost
all commands you need to run.

Write your protocol starting from an outline provided in
`/tasks/perl/protocol.txt`. Make your own copy of the protocol and open
it in an editor, e.g. kate:

``` bash
cp -i /tasks/perl/protocol.txt .   # copy protocol
kate protocol.txt &                # open editor, run in the background
```

### Submitting

  - Directory `/submit/perl/your_username` will be created for you
  - Copy the required files to this directory, including the protocol
    named `protocol.txt`
  - You can modify these files freely until deadline, but after the
    deadline of the homework, you will lose access rights to this
    directory
  - Here is an example of the commands you can use for submitting and
    checking submitted files. Change it to include your username

<!-- end list -->

``` bash
# protocol
cp -ipv protocol.txt /submit/perl/your_username
# tasks A,B
cp -ipv series-stats.pl series-stats.txt fastq2fasta.pl reads-small.fasta reads-tiny.fasta /submit/perl/your_username
# tasks C, D
cp -ipv fastq-quality.pl reads-qualities.tsv fastq-trim.pl reads-small-trim.fastq reads-trim-qualities.tsv /submit/perl/your_username
# check what was submitted
ls -l /submit/perl/your_username
```

### Task A (series)

**Running the script from the lecture**

  - Consider the program for counting series in the [lecture
    1](./Lperl#A_sample_Perl_program.md), save it to file
    `series-stats.pl`
  - Open editor running in the background: `kate series-stats.pl &`
  - Copy and paste text to the editor, save it
  - Make the script executable: `chmod a+x series-stats.pl`
  - Try running it on the small input: `./series-stats.pl <
    /tasks/perl/series-small.tsv`
  - You should get the following output:

<!-- end list -->

    Black Mirror 3
    Game of Thrones 3

**Extending the script**

  - Extend the script to compute the average rating of each series
    (averaging over all episodes in the series)
  - Each row of the input table contains rating in column 5.
  - Output a table with three columns: name of series, the number of
    episodes, the average rating.
  - Use `printf` to print these three items right-justified in columns
    of a sufficient width; print the average rating to 1 decimal place
    (./see [the lecture](Lperl#Formatted_printing.md)).

**Running the script**

  - If you run your script on the small file, the output should look
    something like this (the exact column widths may differ):

<!-- end list -->

    ./series-stats.pl < /tasks/perl/series-small.tsv
            Black Mirror        3        8.2
         Game of Thrones        3        8.8

  - Run your script also on the large file: `./series-stats.pl <
    /tasks/perl/series.tsv > series-stats.txt`
  - Check the output, e.g. by running `cat series-stats.txt`

**Submitting**

  - Submit your script `series-stats.pl` and the output
    `series-stats.txt`

### Task B (FASTQ to FASTA)

**Introduction**

  - In the rest of the assignment, we will write several scripts for
    working with [FASTQ
    files](./Lperl#The_second_input_file_for_today:_DNA_sequencing_reads_.28fastq.29.md)
    introduced in the lecture. Similar scripts are often used by
    bioinformaticians working with DNA sequencing data.
  - We will work with three input files:
      - `/tasks/perl/reads-tiny.fastq` a tiny version of the read file,
        including some corner cases
      - `/tasks/perl/reads-small.fastq` a small version of the read file
      - `/tasks/perl/reads.fastq` a bigger version of the read file

**Goal**

  - Write a script which reformats FASTQ file to FASTA format, call it
    `fastq2fasta.pl`
      - FASTQ file should be on standard input, FASTA file written to
        standard output
  - [FASTA format](https://en.wikipedia.org/wiki/FASTA_format) is a
    typical format for storing DNA and protein sequences.
      - Each sequence consists of several lines of the file. The first
        line starts with "\>" followed by identifier of the sequence and
        optionally some further description separated by whitespace.
      - The sequence itself is on the second line, long sequences can be
        split into multiple lines.
  - In our case, the name of the sequence will be the ID of the read
    with the initial `@` replaced by `>` and each `/` replaced by (`_`).
      - You can try to use [`tr` or `s` regular expression
        operators](http://perldoc.perl.org/perlop.html#Quote-Like-Operators)
        (./see also the [lecture](Lperl#Regular_expressions.md))
  - For example, the first two reads of the file
    `/tasks/perl/reads.fastq` are as follows (only the first 50 columns
    shown)

<!-- end list -->

    @SRR022868.1845/1
    AAATTTAGGAAAAGATGATTTAGCAACATTTAGCCTTAATGAAAGACCAG...
    +
    IICIIIIIIIIIID%IIII8>I8III1II,II)I+III*II<II,E;-HI...
    @SRR022868.1846/1
    TAGCGTTGTAAAATAAATTTCTAGAATGGAAGTGATGATATTGAAATACA...
    +
    4CIIIIIIII52I)IIIII0I16IIIII2IIII;IIAII&I6AI+*+&G5...

  - These should be reformatted as follows (again only first 50 columns
    shown, but you include entire reads):

<!-- end list -->

    >SRR022868.1845_1
    AAATTTAGGAAAAGATGATTTAGCAACATTTAGCCTTAATGAAAGACCAGA...
    >SRR022868.1846_1
    TAGCGTTGTAAAATAAATTTCTAGAATGGAAGTGATGATATTGAAATACAC...

**Start programming**

  - You can start by modifying our script
    `/tasks/perl/fastq-lengths.pl`, which prints the length of each read
    in the FASTQ input file. You can use the following commands to
    start:

<!-- end list -->

    # copy our script to your folder under the new name
    cp -i /tasks/perl/fastq-lengths.pl fastq2fasta.pl
    # open in editor in background
    kate fastq2fasta.pl & 

**Running the script**

  - Run your script on the tiny file, compare with our precomputed
    correct answer:

<!-- end list -->

    ./fastq2fasta.pl < /tasks/perl/reads-tiny.fastq > reads-tiny.fasta
    diff reads-tiny.fasta /tasks/perl/reads-tiny.fasta

  - Command `diff` prints differences between files. Here the output of
    `diff` should be empty. Otherwise try to look at the input and
    output files and fix your program to obtain the same output as we
    have.

<!-- end list -->

  - Also run your script on the small read file

<!-- end list -->

    ./fastq2fasta.pl < /tasks/perl/reads-small.fastq > reads-small.fasta

**Submitting**

  - Submit files `fastq2fasta.pl`, `reads-small.fasta`,
    `reads-tiny.fasta`

### Task C (FASTQ quality)

**Goal**

  - Write a script `fastq-quality.pl` which for each position in a read
    computes the average quality.
  - FASTQ file should be on standard input. It contains multiple reads,
    possibly of different lengths.
  - As quality we will use ASCII values of characters in the quality
    string with value 33 subtracted.
      - For example character 'A' (ASCII 65) means quality 32.
      - ASCII value can be computed by function
        [`ord`](http://perldoc.perl.org/functions/ord.html).
  - Positions in reads will be numbered from 0.
  - Since reads can differ in length, some positions are used in more
    reads, some in fewer.
  - For each position from 0 up to the highest position used in some
    read, print three numbers separated by tabs "\\t": the position
    index, the number of times this position was used in reads, the
    average quality at that position with 1 decimal place (you can again
    use `printf`).

**Example**

  - The first and last lines when you run `./fastq-quality.pl <
    /tasks/perl/reads-tiny.fastq` should be

<!-- end list -->

    0   5   28.2
    1   5   33.0
    ...
    20  2   32.0
    21  2   32.0

For example position 1 occurs in all reads and the qualities are
B,A,B,A,D, which have ASCII values 66, 65, 66, 65, 68. After subtracting
33 from each and averaging we get 33. On the last position (21), we have
only two reads with qualities A, which translates to value 32.

**Running**

  - Run the following commands, which runs your script on the large
    FASTQ file and selects every 10th position. The output is stored in
    `reads-qualities.tsv` and printed using `cat`

<!-- end list -->

``` bash
./fastq-quality.pl < /tasks/perl/reads.fastq | perl -lane 'print if $F[0] % 10 == 0' > reads-qualities.tsv
cat reads-qualities.tsv
```

  - This input is a sample of real sequencing data from Illumina
    technology. What trends (if any) do you see in quality values with
    increasing position?

**Submitting**

  - Submit `fastq-quality.pl`, `reads-qualities.tsv`
  - In the protocol, discuss the question stated above regarding
    `reads-qualities.tsv`

### Task D (FASTQ trim)

**Goal**

  - Write script `fastq-trim.pl` that trims low quality bases from the
    end of each read and filters out short reads.
  - This script should read a FASTQ file from the standard input and
    write trimmed FASTQ file to the standard output.
  - It should also accept two command-line arguments: character *Q* and
    integer *L*.
      - We have not covered processing command line arguments, but you
        can use the code snippet below.
  - *Q* is the minimum acceptable quality (characters from quality
    string with ASCII value \>= ASCII value of *Q* are ok).
  - *L* is the minimum acceptable length of a read.
  - First find the **last base** in a read which has quality at least
    *Q* (if any). All bases after this base will be removed from both
    the sequence and the quality string.
  - If the resulting read has fewer than *L* bases, it is omitted from
    the output.

**Testing**

  - You can check your program by the following tests.

<!-- end list -->

  - If you run the following two commands, nothing should be filtered
    out and thus you should get file `tmp` identical with input and thus
    output of the `diff` command should be empty.

<!-- end list -->

``` bash
# trim at quality ASCII >=33 and length >=1
./fastq-trim.pl '!' 1 < /tasks/perl/reads-tiny.fastq > tmp
diff /tasks/perl/reads-tiny.fastq tmp
```

  - If you run the following two commands, nothing is trimmed but the
    shortest read should be filtered out. Comparing with our solution
    should produce no differences.

<!-- end list -->

``` bash
# trim at quality ASCII >=33 and length >=1
./fastq-trim.pl '!' 5 < /tasks/perl/reads-tiny.fastq > reads-tiny-trim1.fastq
diff reads-tiny-trim1.fastq /tasks/perl/reads-tiny-trim1.fastq
```

  - If you run the following two commands, you should see actual
    trimming of bases with quality A in many reads and one read is
    omitted. Again, you should see no differences from our output.

<!-- end list -->

``` bash
./fastq-trim.pl B 1 < /tasks/perl/reads-tiny.fastq > reads-tiny-trim2.fastq
diff reads-tiny-trim2.fastq /tasks/perl/reads-tiny-trim2.fastq
```

  - If you run the following commands, you should get empty output (no
    reads meet the criteria):

<!-- end list -->

``` bash
./fastq-trim.pl d 1 < /tasks/perl/reads-small.fastq           # quality ASCII >=100, length >= 1
./fastq-trim.pl '!' 102 < /tasks/perl/reads-small.fastq       # quality ASCII >=33 and length >=102
```

**Further runs**

  - `./fastq-trim.pl '(' 95 < /tasks/perl/reads-small.fastq >
    reads-small-trim.fastq # quality ASCII >= 40`
  - If you have done task C, run quality statistics on the trimmed
    version of the bigger file using the commands below. Comment on the
    differences between statistics on the whole file in part C and
    filtered file in D. Are they as you expected?

<!-- end list -->

``` bash
# "2" means quality ASCII >= 50
./fastq-trim.pl 2 50 < /tasks/perl/reads.fastq | ./fastq-quality.pl | perl -lane 'print if $F[0] % 10 == 0' > reads-trim-qualities.tsv
cat reads-trim-qualities.tsv
```

**Submitting**

  - Submit files `fastq-trim.pl`, `reads-small-trim.fastq`,
    `reads-trim-qualities.tsv`
  - In your protocol, include your discussion of the results for
    `reads-trim-qualities.tsv`

**Note**

  - In this task set, you have created tools which can be combined, e.g.
    you can first trim FASTQ and then convert it to FASTA.

**Parsing command-line arguments**

  - Use the following snippet, which stores command-line arguments in
    variables `$Q` and `$L`:

<!-- end list -->

``` Perl
#!/usr/bin/perl -w
use strict;

my $USAGE = "
Usage:
$0 Q L < input.fastq > output.fastq

Trim from the end of each read bases with ASCII quality value less
than the given threshold Q. If the length of the read after trimming
is less than L, the read will be omitted from output.

L is a non-negative integer, Q is a character
";

# check that we have exactly 2 command-line arguments
die $USAGE unless @ARGV==2;
# copy command-line arguments to variables Q and L
my ($Q, $L) = @ARGV;
# check that $Q is one character and $L looks like a non-negative integer
die $USAGE unless length($Q)==1 && $L=~/^[0-9]+$/;
```

