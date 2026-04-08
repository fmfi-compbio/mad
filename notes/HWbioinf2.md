---
title: HWbioinf2
---

* TOC
{:toc}

See also the [lecture](./Lbioinf2.md).

Submit the protocol and the required files to `/submit/bioinf2`

### Input files

Copy files from /tasks/bioinf2/

``` bash
mkdir bioinf2
cd bioinf2
cp -iv /tasks/bioinf2/* .
```

Files:

  - `ref.fasta` is a 38kb piece of the genome of the fungus
    *[Aspergillus
    nidulans](https://www.ncbi.nlm.nih.gov/genome?term=aspergillus%20fumigatus)*
  - `rnaseq.fastq` are RNA-seq reads from Illumina sequencer extracted
    from the [Short read
    archive](https://www.ncbi.nlm.nih.gov/sra/?term=SRR4048918)
  - `annot.gff` is the reference gene annotation from the database (we
    will consider this as correct gene positions)

### Task A: Gene finding

Run the Augustus gene finder with two versions of parameters:

  - one trained specifically for *A. nidulans* genes
  - one trained for the human genome, where genes have different
    statistical properties (for example, they are longer and have more
    introns)

<!-- end list -->

``` bash
augustus --species=anidulans ref.fasta > augustus-anidulans.gtf
augustus --species=human ref.fasta > augustus-human.gtf
```

The results of gene finding are in the GTF format. Examine the files and
try to find the answers to the following questions using command-line
tools.

(a) How many exons are in each of the two GTF files? (Beware: simply
using `grep` with pattern `CDS` may yield lines containing this string
in a different column. You can use e.g. techniques from the
[lecture](./Lbash.md) and [exercises](./HWbash.md) on
command-line tools).

(b) How many genes are in each of the two GTF files? (The files contain
rows with word `gene` in the second column, one for each gene)

(c) How many exons and genes are in the `annot.gff` file with reference
annotation?

Write the answers and commands to the **protocol**. **Submit** files
`augustus-anidulans.gtf` and `augustus-human.gtf`.

### Task B: Aligning RNA-seq reads

  - Align RNA-seq reads to the genome.
  - We will use a specialized tool `STAR`, which can recognize introns.
  - First, run the following commands:

<!-- end list -->

``` bash
STAR --runMode genomeGenerate --genomeDir ref-index --genomeFastaFiles ref.fasta  --genomeSAindexNbases 6
STAR --genomeDir ref-index --alignIntronMax 10000 --readFilesIn rnaseq.fastq  --outFileNamePrefix rnaseq-star.
```

  - Then sort the resulting SAM file using samtools, store it as a BAM
    file and create its index, similarly as in the [previous
    homework](./HWbioinf1.md).
  - In addition to the BAM file, we produced a file
    `rnaseq-star.SJ.out.tab` containing the position of detected introns
    (here called splice junctions or splices). Find in the [manual of
    STAR](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf)
    description of this file.
  - There are also additional files with logs and statistics.

Examine the files to find out answers to the following questions (you
can find some of the answers manually by looking at the the files, e.g.
by `less` command):

(a) How many reads were in the FASTQ file? How many of them were
successfully mapped?

(b) How many introns (splice junctions) were predicted? How many of them
are supported by more than one read?

Finally, convert the file with splice junctions to BED format in which
each line will be one intron. It should have the following columns:

  - Sequence name (as in the `SJ.out.tab` file)
  - Start (beware, it should be 1 less than the number in the SJ.out.tab
    file because of 1-based vs. 0-based coordinates)
  - End (as in the `SJ.out.tab` file)
  - Name (create some identifier, e.g. numbering the junctions
    sequentially)
  - Score (use the number of supporting reads as score)
  - Strand (+, -, or ., needs to be converted from numeric value in
    `SJ.out.tab`)

For conversion, you can write a short script in your favorite language
or use a one-liner. The result should be named
`rnaseq-star-introns.bed`.

Write your answers to the **protocol**. **Submit** the files
`rnaseq-star.bam` and `rnaseq-star-introns.bed`.

### Task C: Computing gene expression

  - To compute gene expression using kallisto, we first need to extract
    the mRNA sequences in FASTA format

```
gffread -w mrna.annot.fa -g ref.fasta annot.gff
```

  - We then need to create the index required by kallisto and finally
    quantify the mRNA sequences using the reads:

```
# 1. Indexing
kallisto index --index kallisto.idx mrna.annot.fa
# 2. Quantification
kallisto quant --index kallisto.idx -o kallisto-quant --single rnaseq.fastq -l 250 -s 100
```
  - Quantification is stored in the `kallisto-quant/abundance.tsv` file
    (Tab-Separated Values format)
  - TPM stands for Transcripts Per Million and is a way to convert raw
    reads counts to transcripts (mRNA) abundances. TPM normalizes raw
    reads counts for gene length and for sequencing depth so that the
    sum of TPMs in a sample = 1000000.
  - Note: TPM are higher than usual due to the limited number of genes
    we are quantifying
  - More information on the output .tsv file can be found in the
    [kallisto manual](https://pachterlab.github.io/kallisto/manual.html)

Examine the .tsv file to find out answers to the following questions:

(a) How many mRNA are not expressed? Which one(s)?

(b) Does TPM values sum to 1000000? If not, do you have any idea why?

(c) What is the (estimated) fraction of reads used in the quantification
    step? (you can divide the sum of est_counts column by the total
    number of reads in the FASTQ file)

(d) Why not all reads have been used? (it might be easier to answer
    this question after completing the next task)

Write your answers to the **protocol**. **Submit** the file `abundance.tsv`.

### Task D: Visualizing in IGV

As before, run IGV as follows:

``` bash
igv -g ref.fasta &
```

Open additional files using menu `File -> Load from File`: `annot.gff,
augustus-anidulans.gtf, augustus-human.gtf, rnaseq.bam,
rnaseq-star-introns.bed`

  - In GTF and GFF files, exons are shown as thicker boxes, introns are
    thinner.
  - You can change how annotations are displayed by right-clicking on the
    left part of the corresponding track (where the name of the file is
    shown). Suggested view: "Expanded". In this way, introns are displayed
    as lines. Moreover, all mRNAs IDs/names are displayed
    (e.g., ID=rna158 and name=XM_659157.1).
  - For each of the following questions, select a part of the sequence
    illustrating the answer and export a figure using `File->Save image`
  - You can check these images using command `eog`

Questions:

(a) Create an image illustrating differences between Augustus with human
parameters and the reference annotation, save as `a.png`. Briefly
describe the differences in words.

(b) Find the most expressed gene (from kallisto output) and zoom in to
its region. Store the image as `b.png`. Is there any differerence between
the annotations? Which parameters have yielded a more accurate prediction?
Try to find how many spliced read alignments supports the annotated intron
boundaries. Does this number coincide with the number reported by STAR?


**Submit** files `a.png, b.png`. Write answers to your **protocol**.

