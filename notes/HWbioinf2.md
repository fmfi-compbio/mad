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

### Task C: Visualizing in IGV

As before, run IGV as follows:

``` bash
igv -g ref.fasta &
```

Open additional files using menu `File -> Load from File`: `annot.gff,
augustus-anidulans.gtf, augustus-human.gtf, rnaseq.bam,
rnaseq-star-introns.bed`

  - In GTF and GFF files, exons are shown as thicker boxes, introns are
    thinner.
  - For each of the following questions, select a part of the sequence
    illustrating the answer and export a figure using `File->Save image`
  - You can check these images using command `eog`

Questions:

(a) Create an image illustrating differences between Augustus with human
parameters and the reference annotation, save as `a.png`. Briefly
describe the differences in words.

(b) Find some differences between Augustus with *A. nidulans* parameters
and the reference annotation. Store an illustrative figure as `b.png`.
Which parameters have yielded a more accurate prediction?

(c) Zoom in to one of the genes with a high expression level and try to
find spliced read alignments supporting the annotated intron boundaries.
Store the image as `c.png`.

**Submit** files `a.png, b.png, c.png`. Write answers to your
**protocol**.

