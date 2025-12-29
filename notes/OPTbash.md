---
title: OPTbash
---

* TOC
{:toc}

This is an optional set of exercises for lecture on command-line tools
(./[Lbash](Lbash.md)). They use a bioinformatics input file with
annotation of the yeas genome.

### Task A (yeast genome)

**The input file:**

  - `/tasks/optional/bash/saccharomyces_cerevisiae.gff` contains
    annotation of the yeast genome
      - Downloaded from <http://yeastgenome.org/> on 2016-03-09, in
        particular from
        [1](http://downloads.yeastgenome.org/curation/chromosomal_feature/saccharomyces_cerevisiae.gff).
      - It was further processed to omit DNA sequences from the end of
        file.
      - The size of the file is 5.6M.
  - For easier work, link the file to your directory by `ln -s
    /tasks/optional/bash/saccharomyces_cerevisiae.gff yeast.gff`
  - The file is in [GFF3
    format](http://www.sequenceontology.org/gff3.shtml)
  - The lines starting with `#` are comments, other lines contain
    tab-separated data about one interval of some chromosome in the
    yeast genome
  - Meaning of the first 5 columns:
      - column 0 chromosome name
      - column 1 source (can be ignored)
      - column 2 type of interval
      - column 3 start of interval (1-based coordinates)
      - column 4 end of interval (1-based coordinates)
  - You can assume that these first 5 columns do not contain whitespace

**Task:**

  - Print for each type of interval (column 2), how many times it occurs
    in the file.
  - Sort from the most common to the least common interval types.
  - Hint: commands `sort` and `uniq` will be useful. Do not forget to
    skip comments, for example using `grep -v '^#'`
  - The result should be a file `types.txt` formatted as follows:

<!-- end list -->

``` 
   7058 CDS
   6600 mRNA
...
...
      1 telomerase_RNA_gene
      1 mating_type_region
      1 intein_encoding_region
```

### Task B (chromosomes)

  - Continue processing file from task A.
  - For each chromosome, the file contains a line which has in column 2
    string `chromosome`, and the interval is the whole chromosome.
  - To file `chrosomes.txt`, print a tab-separated list of chromosome
    names and sizes in the same order as in the input
  - The last line of `chromosomes.txt` should list the total size of all
    chromosomes combined.

<!-- end list -->

  - Hints:
      - The total size can be computed by a perl one-liner.
      - Example from the lecture: compute the sum of interval sizes if
        each line of the file contains start and end of one interval:
        `perl -lane'$sum += $F[1]-$F[0]; END { print $sum; }'`
      - Grepping for word chromosome does not check if this word is
        indeed in the second column
      - Tab character is written in Perl as `"\t"`.
  - Your output should start and end as follows:

<!-- end list -->

    chrI    230218
    chrII   813184
    ...
    ...
    chrXVI  948066
    chrmt   85779
    total   12157105

