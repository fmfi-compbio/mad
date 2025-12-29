---
title: HWbioinf3
---

* TOC
{:toc}

See also the [lecture](./Lbioinf3.md)

Submit the protocol and the required files to `/submit/bioinf3`

### Input files

Copy files from /tasks/bioinf3/

``` bash
mkdir bioinf3
cd bioinf3
cp -iv /tasks/bioinf3/* .
```

Files:

  - `humanChr7Region.fasta` is a 7kb piece of the human chromosome 7
  - `motherChr7Region.fastq` is a sample of reads from an anonymous
    donor known as NA12878; these reads come from region in
    `humanChr7Region.fasta`
  - `fatherChr12.vcf` and `motherChr12.vcf` are single-nucleotide
    variants on the chromosome 12 obtained by sequencing two individuals
    NA12877, NA12878 (these come from a larger
    [family](https://www.coriell.org/0/Sections/Collections/NIGMS/CEPHFamiliesDetail.aspx?PgId=441&fam=1463&))

### Task A: read mapping and variant calling

Align reads to the reference:

``` bash
bwa index humanChr7Region.fasta
bwa mem humanChr7Region.fasta  motherChr7Region.fastq | \
  samtools view -S -b - |  samtools sort - -o motherChr7Region.bam
samtools index motherChr7Region.bam
```

Call variants:

``` bash
freebayes -f humanChr7Region.fasta --min-alternate-count 10 \
  motherChr7Region.bam >motherChr7Region.vcf
```

Run IGV, use `humanChr7Region.fasta` as genome, open
`motherChr7Region.bam` and `motherChr7Region.vcf`. Looking at the
aligned reads and the VCF file, **answer** the following questions:

(a) How many variants were found in the VCF file?

(b) How many variants are heterozygous and how many are homozygous?

(c) Are all variants single-nucleotide variants or do you also see some
insertions/deletions (indels)?

Also export the overall view of the whole region from IGV to file
`motherChr7Region.png`.

**Submit** the following files: `motherChr7Region.png,
motherChr7Region.bam, motherChr7Region.vcf`

### Task B: UCSC genome browser

(a) Where is the sequence from `humanChr7Region.fasta` file located in
the browser?

  - Go to <http://genome-euro.ucsc.edu/>, from the blue menu, select
    `Tools->Blat`
  - Check that Blat uses Human, hg38 assembly
  - Open `humanChr7Region.fasta` in a graphical editor (e.g. `kate`),
    select all, paste to the BLAT window, run BLAT.
  - In the table of results, the best result should have identity close
    to 100% and span close to 7kb.
  - For this best result, click on the link named Browser.
  - Report which chromosome and which region you get.

(b) Which gene is located in this region?

  - Once you are in the browser, you should see a track called GENCODE
    (if not, you can turn it on in the section Genes and Gene
    Predictions).
  - This track contains known genes, shown as rectangles (exons)
    connected by lines (introns). Short gene names are next to them.
  - Report the name of the gene in the region.

(c) In which tissue is this gene most highly expressed? What is the
function of this gene?

  - When you click on the gene (possibly twice), you get an information
    page. The UniProtKB section includes a description of its function.
    Copy the first sentence to your protocol.
  - Further down on the gene information page you see RNA-Seq Expression
    Data (colorful boxplots). Find out which tissue haves the highest
    signal.

(d) Which SNPs are located in this gene? Which trait do they influence?

  - You can see SNPs in the dbSNPs track, but their IDs appear only
    after switching this track to pack or full mode. You can click on
    each SNPs to see more information and to copy their ID to your
    protocol.
  - Information page of the gene (part c) describes function of various
    alleles of this gene (see e.g. part POLYMORPHISM).
  - You can also find information about individual SNPs by looking for
    them by their ID in
    [SNPedia](https://www.snpedia.com/index.php/SNPedia) (not required
    in this task).

### Task C: Examining larger vcf files

In this task, we will look at `motherChr12.vcf` and `fatherChr12.vcf`
files and compute various statistics. You can use command-line tools,
such as `grep, wc, sort, uniq` and Perl one-liners (as in
[Lbash](./Lbash.md)), or you can write small scripts in Perl or
Python (./as in [Lperl](Lperl.md) and [Lsql](./Lsql.md)).

  - Write all used commands to your protocol.
  - If you write any scripts, submit them as well.

Questions:

(a) How many SNPs are in each file?

  - This can be found easily by `wc`, only make sure to exclude lines
    with comments.

(b) How many heterozygous SNPs are in each file?

  - The last column contains `1|1` for homozygous and either `0|1` or
    `1|0` for heterozygous SNPs.
  - Character `|` has a special meaning on the command line and in
    `grep` patterns; make sure to place it in apostrophes `' '` and
    possibly escape it with backslash `\`.

(c) How many SNP positions are shared between the two files?

  - The second column of each file lists the position. We want to
    compute the size of intersection of the set of positions in
    `motherChr12.vcf` and `fatherChr12.vcf` files.
  - You can create temporary files containing only positions from the
    two files and sort them alphabetically. Then you can find the
    intersection using
    [comm](http://www.gnu.org/software/coreutils/manual/html_node/comm-invocation.html)
    command with options `-1 -2`. Alternatively, you can store positions
    as keys in a hash table (dictionary) in a Perl or Python script.

(d) List the 5 most frequent pairs of reference/alternate allele in
`motherChr12.vcf` and their frequencies. Do they correspond to
transitions or transversions?

  - The fourth column contains the reference allele, fifth column the
    alternate allele. For example, the first SNP in `motherChr12.vcf`
    has a pair `C,A`.
  - For each possible pair of nucleotides, find how many times it occurs
    in the `motherChr12.vcf` file.
  - For example, pair `C,A` occurs 6894 times.
  - Then sort the pairs by their frequencies and report the 5 most
    frequent pairs.
  - Mutations can be classified as transitions and transversions.
    Transitions change a purine to a purine or a pyrimidine to a
    pyrimidine, transversions change a purine to a pyrimidine or vice
    versa. For example, pair C,A is a transversion changing pyrimidine C
    to purine A. Which of these most frequent pairs correspond to
    transitions and which to transversions?
  - To count pairs without writing scripts, you can create a temporary
    file containing only columns 4 and 5 (without comments), and then
    use commands `sort` and `uniq` to count each pair.

(e) Which parts of the chromosome have the highest and lowest density of
SNPs in </tt>motherChr12.vcf</tt>?

  - First create a list of windows of size 100kb covering the whole
    chromosome 12 using these two commands:

<!-- end list -->

    perl -le 'print "chr12\t133275309"' > humanChr12.size
    bedtools makewindows -g humanChr12.size -w 100000 -i srcwinnum > humanChr12-windows.bed

  - Then count SNPs in each window using this command:

<!-- end list -->

    bedtools coverage -a  humanChr12-windows.bed -b motherChr12.vcf > motherChr12-windows.tab

  - Find out which column of the resulting file contains the number of
    SNPs per window, e.g. by reading the documentation obtained by
    command `bedtools coverage -h`
  - Sort according to the column with the SNP number, look at the first
    and last line of the sorted file.
  - For checking: the second highest count is 387 in window with
    coordinates `20,800,000-20,900,000`.
  - Just for information: The median is 119 SNPs.

