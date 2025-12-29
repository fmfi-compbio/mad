---
title: HWpar
---

* TOC
{:toc}

See also the [lecture](./Lpar.md)

Deadline: 22th May 2025 9:00

For both tasks, submit your source code and the result, when run on
whole dataset (`/tasks/par/dataset`). The code is expected to use the
Apache beam framework presented in the lecture. Submit directory is
`/submit/par/`

Ideally, you should run the code locally on your computer or try some
cloud providers if you want.

### Task A

Count the number of occurrences of each 4-mer in the provided data.

Provided data are in Fastq format. They contain reads from some genomic
sequencing. By a read we mean part of some DNA. In Fastq format each
read is on 4 lines. The first line starts with @ and contains the read
name. The second line contains the actual read (this is the important
part for you). The third line contains + and the read name again. The
fourth line contains a quality score for each base (you should ignore
this).

By k-mer we mean any consecutive substring in a read. For example, in a
read "ACGGCTA" the 4-mers are: "ACGG", "CGGC", "GGCT", "GCTA".

### Task B

Count the number of pairs of reads that overlap in exactly 30 bases (the
end of one read overlaps the beginning of the second read). For
bioinformaticians: You can ignore the reverse complement.

One more clarification: If you have two reads (and say we are counting 4
base overlaps): AAAAxxxxxCCCC and CCCCxxxxxAAAA, this counts as two
overlaps.

Hints:

  - Try counting pairs for each 30-mer first.
  - You can yield something structured from Map/ParDo operatation (e.g.
    tuple).
  - You can have another Map/ParDo after CombinePerKey.
  - Run code on small data (subset of all files or even one file or even
    your small custom data) to quickly iterate and test :)

