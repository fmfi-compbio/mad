---
title: Lbioinf3
---

* TOC
{:toc}

[HWbioinf3](./HWbioinf3.md)

## Polymorphisms

  - Individuals within species differ slightly in their genomes.
  - Polymorphisms are genome variants which are relatively frequent in a
    population (e.g. at least 1%).
  - SNP: single-nucleotide polymorphism (a polymorphism which is a
    substitution of a single nucleotide).
  - Recall that most human cells are diploid, with one set of
    chromosomes inherited from the mother and the other from the father.
  - At a particular chromosomal location, a single human can thus have
    two different alleles (heterozygot) or two copies of the same allele
    (homozygot).

## Finding polymorphisms / genome variants

  - We compare sequencing reads coming from an individual to a reference
    genome of the species.
  - First we align them, as in [the exercises on genome
    assembly](./HWbioinf1.md).
  - Then we look for positions where a substantial fraction of the reads
    does not agree with the reference (this process is called variant
    calling).

## Programs and file formats

  - For mapping, we will use [`BWA-MEM`](https://github.com/lh3/bwa)
    (you can also try Minimap2, as in [the exercises on genome
    assembly](./HWbioinf1.md)).
  - For variant calling, we will use
    [FreeBayes](https://github.com/ekg/freebayes).
  - For reads and read alignments, we will use FASTQ and BAM files, as
    in the [previous lectures](./Lbioinf1.md).
  - For storing found variants, we will use [VCF
    files](http://www.internationalgenome.org/wiki/Analysis/vcf4.0/).
  - For storing genome intervals, we will use [BED
    files](https://genome.ucsc.edu/FAQ/FAQformat.html#format1) as in the
    [previous lecture](./Lbioinf2.md).

## Human variants

  - For many human SNPs we already know something about their influence
    on phenotype and their prevalence in different parts of the world.
  - There are various databases, e.g.
    [dbSNP](https://www.ncbi.nlm.nih.gov/SNP/),
    [OMIM](https://www.omim.org/), or user-editable
    [SNPedia](https://www.snpedia.com/index.php/SNPedia).

## UCSC genome browser

A short video for this section: [1](https://youtu.be/RwEBS62Avaw)

  - The [UCSC genome browser](http://genome-euro.ucsc.edu/) is an
    on-line tool similar to IGV.
  - It has nice interface for browsing genomes, lot of data for some
    genomes (particularly human), but not all sequenced genomes
    represented.

#### Basics

  - On the front page, choose Genomes in the top blue menu bar.
  - Select a genome and its version, optionally enter a position or a
    keyword, press submit.
  - On the browser screen, the top image shows chromosome map, the
    selected region is in red.
  - Below there is a view of the selected region and various tracks with
    information about this region.
  - For example some of the top tracks display genes (boxes are exons,
    lines are introns).
  - Tracks can be switched on and off and configured in the bottom part
    of the page (browser supports different display levels, full
    contains all information but takes a lot of vertical space).
  - Buttons for navigation are at the top (move, zoom, etc.).
  - Clicking at the browser figure allows you to get more information
    about a gene or other displayed item.
  - In this lecture, we will need tracks GENCODE and dbSNP - check e.g.
    [gene
    ACTN3](http://genome-euro.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr11%3A66546841-66563329)
    and within it SNP `rs1815739` in exon 15.

#### Blat

  - For sequence alignments, UCSC genome browser offers a fast but less
    sensitive BLAT (good for the same or very closely related species).
  - Choose `Tools->Blat` in the top blue menu bar, enter DNA sequence
    below, search in the human genome.
      - What is the identity level for the top found match? What is its
        span in the genome? (Notice that other matches are much
        shorter).
      - Using Details link in the left column you can see the alignment
        itself, Browser link takes you to the browser at the matching
        region.

<!-- end list -->

    AACCATGGGTATATACGACTCACTATAGGGGGATATCAGCTGGGATGGCAAATAATGATTTTATTTTGAC
    TGATAGTGACCTGTTCGTTGCAACAAATTGATAAGCAATGCTTTCTTATAATGCCAACTTTGTACAAGAA
    AGTTGGGCAGGTGTGTTTTTTGTCCTTCAGGTAGCCGAAGAGCATCTCCAGGCCCCCCTCCACCAGCTCC
    GGCAGAGGCTTGGATAAAGGGTTGTGGGAAATGTGGAGCCCTTTGTCCATGGGATTCCAGGCGATCCTCA
    CCAGTCTACACAGCAGGTGGAGTTCGCTCGGGAGGGTCTGGATGTCATTGTTGTTGAGGTTCAGCAGCTC
    CAGGCTGGTGACCAGGCAAAGCGACCTCGGGAAGGAGTGGATGTTGTTGCCCTCTGCGATGAAGATCTGC
    AGGCTGGCCAGGTGCTGGATGCTCTCAGCGATGTTTTCCAGGCGATTCGAGCCCACGTGCAAGAAAATCA
    GTTCCTTCAGGGAGAACACACACATGGGGATGTGCGCGAAGAAGTTGTTGCTGAGGTTTAGCTTCCTCAG
    TCTAGAGAGGTCGGCGAAGCATGCAGGGAGCTGGGACAGGCAGTTGTGCGACAAGCTCAGGACCTCCAGC
    TTTCGGCACAAGCTCAGCTCGGCCGGCACCTCTGTCAGGCAGTTCATGTTGACAAACAGGACCTTGAGGC
    ACTGTAGGAGGCTCACTTCTCTGGGCAGGCTCTTCAGGCGGTTCCCGCACAAGTTCAGGACCACGATCCG
    GGTCAGTTTCCCCACCTCGGGGAGGGAGAACCCCGGAGCTGGTTGTGAGACAAATTGAGTTTCTGGACCC
    CCGAAAAGCCCCCACAAAAAGCCG

