---
title: HWbioinf1
---

* TOC
{:toc}

See also the [lecture](./Lbioinf1.md)

Submit the protocol and the required files to `/submit/bioinf1`

### Technical notes

  - Task D and task E ask you to look at data visualizations.
  - If you are unable to open graphical applications from our server,
    you can download appropriate files and view them on your computer
    (in task D these are simply pdf files, in task E you can install IGV
    software on your computer or use the [online
    version](https://igv.org/app/)).

### Task A: examine input files

Copy files from `/tasks/bioinf1/` as follows:

``` bash
mkdir bioinf1
cd bioinf1
cp -iv /tasks/bioinf1/* .
```

  - File `ref.fasta` contains a piece of genome from *Escherichia coli*.
  - Files `miseq_R1.fastq.gz` and `miseq_R2.fastq.gz` contain sequencing
    reads from Illumina MiSeq sequencer. First reads in pairs are in the
    R1 file, second reads in the R2 file. These reads come from the
    region in `ref.fasta`.
  - File `nanopore.fasta` contains nanopore sequencing reads in FASTA
    format (without qualities). These reads are also from the region in
    `ref.fasta`.

Try to find the answers to the following questions using command-line
tools. In your **protocol**, note down the **commands** as well as the
**answers**.

(a) How many reads are in the MiSeq files? Is the number of reads the
same in both files?

  - Try command `zcat miseq_R1.fastq.gz | wc -l`
  - Can you figure out the answer from the result of this command?

(b) How long are individual reads in the MiSeq files?

  - Look at the file using `zless` - do all reads appear to be of an
    equal length?
  - Extend the following command with `tail` and `wc -c` to get the
    length of the first read: `zcat miseq_R1.fastq.gz | head -n 2`
  - Do not forget to consider the end of the line character.
  - Repeat for both MiSeq files.

(c) How many reads are in the nanopore file (beware - different format)

(d) What is the average length of the reads in the nanopore file?

  - Try command: `samtools faidx nanopore.fasta`
  - This creates `nanopore.fasta.fai` file, where the second column
    contains sequence length of each read.
  - Compute the average of this column by a one-liner: `perl -lane
    '$s+=$F[1]; $n++; END { print $s/$n }' nanopore.fasta.fai`

(e) How long is the sequence in the `ref.fasta` file?

### Task B: assemble the sequence from the reads

  - We will pretend that the correct answer (`ref.fasta`) is not known
    and we will try to assemble it from the reads.
  - We will assemble Illumina reads by program
    [SPAdes](https://github.com/ablab/spades) and nanopore reads by
    [miniasm](https://github.com/lh3/miniasm).
  - Assembly takes several minutes; we will run it in the background
    using `screen` command.

SPAdes

  - Run `screen -S spades`
  - Press Enter to get the command-line, then run the following
    command:  

<!-- end list -->

  - 
    
      -   
        `spades.py -t 1 -m 1 --pe1-1 miseq_R1.fastq.gz --pe1-2
        miseq_R2.fastq.gz -o spades > spades.log`

<!-- end list -->

  - Press `Ctrl-a` followed by `d`
  - This will take you out of `screen` command ([more details in a
    separate section](./screen.md)).
  - Run `top` command to check that your command is running.

Miniasm

  - Create file `miniasm.sh` containing the following commands:

<!-- end list -->

``` bash
# Find alignments between pairs of reads
minimap2 -x ava-ont -t 1 nanopore.fasta nanopore.fasta | gzip -1 > nanopore.paf.gz 
# Use overlaps to compute the assembled genome
miniasm -f nanopore.fasta nanopore.paf.gz > miniasm.gfa 2> miniasm.log
# Convert genome to fasta format
perl -lane 'print ">$F[1]\n$F[2]" if $F[0] eq "S"' miniasm.gfa > miniasm.fasta
# Align reads to the assembled genome
minimap2 -x map-ont --secondary=no -t 1 miniasm.fasta nanopore.fasta | gzip -1 > miniasm.paf.gz
# Polish the genome by finding consensus of aligned reads at each position
racon -t 1 -u nanopore.fasta miniasm.paf.gz miniasm.fasta > miniasm2.fasta
```

  - Run `screen -S miniasm`.
  - In screen, run `source ./miniasm.sh`
  - Press `Ctrl-a d` to exit `screen`.

To check if your commands have finished:

  - Re-enter the screen environment using `screen -r spades` or `screen
    -r miniasm`
  - If the command finished, terminate `screen` by pressing `Ctrl-d` or
    typing `exit`

Examine the outputs. Write **commands** and **answers** to your
**protocol**.

  - Move the output of SPAdes to a new filename: `mv -i
    spades/contigs.fasta spades.fasta`
  - Output of miniasm should be in `miniasm2.fasta`

(a) How many contigs are in each of these two files?

(b) What can you find out from the names of contigs in `spades.fasta`?
What is the length of the shortest and longest contigs? String `cov` in
the names is abbreviation of read coverage - the average number of reads
covering a position in the contig. Do the reads have similar coverage,
or are there big differences?

  - Use command `grep '>' spades.fasta`

(c) What are the lengths of contigs in `miniasm2.fa` file? (You can use
`LN:i:` in the name of contigs.)

**Submit** files `miniasm2.fasta` and `spades.fasta`

### Task C: compare assemblies using Quast command

We have found basic characteristics of the two assemblies in task B. Now
we will use program [Quast](https://github.com/ablab/quast) to compare
both assemblies to the correct answer in `ref.fa`

``` bash
quast.py -R ref.fasta miniasm2.fasta spades.fasta -o stats
```

**Submit** file `stats/report.txt`.

Look at the results in `stats/report.txt` and **answer** the following
questions.

(a) How many contigs has quast reported in the two assemblies? Does it
agree with your counts in Task B?

(b) What is the number of mismatches per 100kb in the two assemblies?
Which one is better? Why do you think it is so? (look at the properties
of used sequencing technologies in the
[lecture](./Lbioinf1#Overview_of_DNA_sequencing_and_assembly.md))

(c) What portion of the reference sequence is covered by the two
assemblies (reported as `genome fraction`)? Which assembly is better in
this aspect?

(d) What is the length of the longest alignment between contigs and the
reference in the two assemblies? Which assembly is better in this
aspect?

### Task D: create dotplots of assemblies

We will now visualize alignments between each assembly and the reference
genome using dotplots. As in other tasks, write **commands** and
**answers** to your **protocol**.

(a) Create a dotplot comparing miniasm assembly to the reference
sequence

``` bash
# alignments
minimap2 -x asm10 -t 1 ref.fasta miniasm2.fasta > ref-miniasm2.paf
# creating dotplot
/usr/local/share/miniasm/miniasm/minidot -f 12 ref-miniasm2.paf | \
  ps2pdf -dEPSCrop - ref-miniasm2.pdf
# displaying dotplot
# if evince does not work, copy the pdf file to your commputer and view there
evince ref-miniasm2.pdf &
```

  - x-axis is reference, y-axis assembly.
  - Which part of the reference is missing in the assembly?
  - Do you see any other big differences between the assembly and the
    reference?

(b) Use analogous commands to create a dotplot for spades assembly, call
it `ref-spades.pdf`.

  - What are vertical gray lines in the dotplot?
  - Is any contig aligning to multiple places in the reference? To how
    many places?

(c) Use analogous commands to create a dotplot of reference to itself,
call it `ref-ref.pdf`.

  - However, in the minimap2 command add option `-p 0` to include also
    weaker self-alignments.
  - Do you see any self-alignments, showing repeated sequences in the
    reference? Does this agree with the dotplot in part (b)?

**Submit** all three pdf files `ref-miniasm2.pdf`, `ref-spades.pdf`,
`ref-ref.pdf`

### Task E: Align reads and assemblies to reference, visualize in IGV

Finally, we will align all source reads as well as assemblies to the
reference genome, then visualize the alignments in [IGV
tool](https://software.broadinstitute.org/software/igv/) or its [online
version](https://igv.org/app/).

A short video introducing IGV: [1](https://youtu.be/46HhBqGGPU0)

  - Write **commands** and **answers** to your **protocol**
  - **Submit** all four BAM files `ref-miseq.bam`, `ref-nanopore.bam`,
    `ref-spades.bam`, `ref-miniasm2.bam`

(a) Align illumina reads (MiSeq files) to the reference sequence

``` bash
# align illumina reads to reference
# minimap produces SAM file, samtools view converts to BAM, 
# samtools sort orders reads by coordinate
minimap2 -a -x sr --secondary=no -t 1 ref.fasta  miseq_R1.fastq.gz miseq_R2.fastq.gz | \
  samtools view -S -b -o - |  samtools sort - -o ref-miseq.bam
# index BAM file for faster access
samtools index ref-miseq.bam
```

(b) Similarly align nanopore reads, but instead of `-x sr` use `-x
map-ont`, call the result `ref-nanopore.bam`, `ref-nanopore.bam.bai`

(c) Similarly align `spades.fasta`, but instead of `-x sr` use `-x
asm10`, call the result `ref-spades.bam`

(d) Similarly align `miniasm2.fasta`, but instead of `-x sr` use `-x
asm10`, call the result `ref-miniasm2.bam`

(e) Run the IGV viewer. **Beware: It needs a lot of memory, do not keep
open on the server unnecessarily**.

  - `igv -g ref.fasta &`
  - Using `Menu->File->Load from File`, open all four BAM files.
  - Look at region `ecoli-frag:224,000-244,000`.
  - How many spades contigs do you see aligning in this region?
  - Look at region `ecoli-frag:227,300-227,600`.
  - Comment on what you see. How frequent are errors in the individual
    assemblies and read sets?
  - If you are unable to run igv from home, you can install it on your
    computer [2](https://software.broadinstitute.org/software/igv/) and
    download `ref.fasta` and all `.bam` and `.bam.bai` files.

