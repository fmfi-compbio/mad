---
title: HWmake
---

* TOC
{:toc}

See also the [lecture](./Lmake.md)

### Motivation: Building phylogenetic trees

The task for today will be to build a phylogenetic tree of 9 mammalian
species using protein sequences

  - A **phylogenetic tree** is a tree showing evolutionary history of
    these species. Leaves are the present-day species, internal nodes
    are their common ancestors.
  - The **input** contains sequences of all proteins from each species
    (we will use only a smaller subset)
  - The process is typically split into several stages shown below

#### Identify ortholog groups

*Orthologs* are proteins from different species that "correspond" to
each other. Orthologs are found based on sequence similarity and we can
use a tool called
[blast](http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
to identify sequence similarities between pairs of proteins. The result
of ortholog group identification will be a set of groups, each group
having one sequence from each of the 9 species.

#### Align proteins on each group

For each ortholog group, we need to align proteins in the group to
identify corresponding parts of the proteins. This is done by a tool
called `muscle`

Unaligned sequences (start of protein
[O60568](https://www.uniprot.org/uniprot/O60568)):

    >human
    MTSSGPGPRFLLLLPLLLPPAASASDRPRGRDPVNPEKLLVITVA...
    >baboon
    MTSSRPGLRLLLLLLLLPPAASASDRPRGRDPVNPEKLLVMTVA...
    >dog
    MASSGPGLRLLLGLLLLLPPPPATSASDRPRGGDPVNPEKLLVITVA...
    >elephant
    MASWGPGARLLLLLLLLLLPPPPATSASDRSRGSDRVNPERLLVITVA...
    >guineapig
    MAFGAWLLLLPLLLLPPPPGACASDQPRGSNPVNPEKLLVITVA...
    >opossum
    SDKLLVITAA...
    >pig
    AMASGPGLRLLLLPLLVLSPPPAASASDRPRGSDPVNPDKLLVITVA...
    >rabbit
    MGCDSRKPLLLLPLLPLALVLQPWSARGRASAEEPSSISPDKLLVITVA...
    >rat
    MAASVPEPRLLLLLLLLLPPLPPVTSASDRPRGANPVNPDKLLVITVA...

Aligned sequences:

    rabbit       MGCDSRKPLL LLPLLPLALV LQPW-SARGR ASAEEPSSIS PDKLLVITVA ...
    guineapig    MAFGA----W LLLLPLLLLP PPPGACASDQ PRGSNP--VN PEKLLVITVA ...
    opossum      ---------- ---------- ---------- ---------- SDKLLVITAA ...
    rat          MAASVPEPRL LLLLLLLLPP LPPVTSASDR PRGANP--VN PDKLLVITVA ...
    elephant     MASWGPGARL LLLLLLLLLP PPPATSASDR SRGSDR--VN PERLLVITVA ...
    human        MTSSGPGPRF LLLLPLLL-- -PPAASASDR PRGRDP--VN PEKLLVITVA ...
    baboon       MTSSRPGLRL LLLLLLL--- -PPAASASDR PRGRDP--VN PEKLLVMTVA ...
    dog          MASSGPGLRL LLGLLLLL-P PPPATSASDR PRGGDP--VN PEKLLVITVA ...
    pig          AMASGPGLR- LLLLPLLVLS PPPAASASDR PRGSDP--VN PDKLLVITVA ...

#### Build phylogenetic tree for each group

For each alignment, we build a phylogenetic tree for this group. We will
use a program called [IQ-tree](http://www.iqtree.org/).

Example of a phylogenetic tree in newick format:

<div class="float-right">
{% include figure.html
   src="Tree.png"
   width="400px"
   caption="Tree for gene O60568 (note: this particular tree does not agree well
   with real evolutionary history)" %}
</div>
``` 
 ((opossum:0.09636245,rabbit:0.85794020):0.05219782,
(rat:0.07263127,elephant:0.03306863):0.01043531,
(dog:0.01700528,(pig:0.02891345,
(guineapig:0.14451043,
(human:0.01169266,baboon:0.00827402):0.02619598
):0.00816185):0.00631423):0.00800806);
```

#### Build a consensus tree

The result of the previous step will be several trees, one for every
group. Ideally, all trees would be identical, showing the real
evolutionary history of the 9 species. But it is not easy to infer the
real tree from sequence data, so the trees from different groups might
differ. Therefore, in the last step, we will build a consensus tree.
This can be done by using a tool called
[Phylip](https://phylipweb.github.io/phylip/). The output is a single
consensus tree.

### Files and submitting

Our goal is to build a pipeline that automates the whole task using make
and execute it remotely using `qsub`. Most of the work is already done,
only small modifications are necessary.

  - Submit by copying requested files to `/submit/make/username/`
  - Do not forget to submit protocol, outline of the protocol is in
    `/tasks/make/protocol.txt`

Start by copying folder `/tasks/make` to your home folder

``` bash
cp -ipr /tasks/make .
cd make
```

The folder contains three subfolders:

  - `large`: a larger sample of proteins for task A
  - `tiny`: a very small set of proteins for task B
  - `small`: a slightly larger set of proteins for task C

When you are done, you can **submit** all required files as follows
(substitute your username):

``` bash
cd ~/make
cp -ipvr protocol.txt large/queue.txt large/make.o* large/ref-end.blast tiny small /submit/make/your_username

# check what was submitted
ls -lr /submit/make/your_username
```

### Task A (long job)

  - In this task, you will run a long alignment job (more than two
    hours).
  - Go to folder `large`, which contains the following files:
      - `ref.fa`: selected human proteins
      - `other.fa`: selected proteins from 8 other mammalian species
      - `Makefile`: runs blast on `ref.fa` vs `other.fa` (also formats
        database `other.fa` before that)
  - Run command the following command to see what commands will be done
    by make (you should see `makeblastdb`, `blastp`, and `echo` for
    timing):  
    `make -n > make-n.txt; cat make-n.txt`
  - Run `qsub` with appropriate options (at least `-cwd -b y`) to run
    command `make`.
  - Then run the following to check the queue:  
    `qstat > queue.txt ; cat queue.txt`
      - The output should show your jobs waiting in queue or running
  - When your job finishes, check the following files:
      - the output file `ref.blast`
      - standard output from the `qsub` job, which is stored in a file
        named e.g. `make.oX` where `X` is the number of your job. The
        output shows the time when your job started and finished (this
        information was written by commands `echo` in the `Makefile`)
  - **Submit** the following files:
      - File `queue.txt` showing your job waiting or running in the
        queue
      - File `make.oX` with output of your job
      - The last 100 lines from `ref.blast` under the name
        `ref-end.blast` (use tool `tail -n 100`)

### Task B (finishing Makefile)

  - In this task, you will finish a `Makefile` for splitting blast
    results into ortholog groups and building phylogenetic trees for
    each group.
      - This `Makefile` works with much smaller files and so you can run
        it quickly many times without `qsub`
  - Work in folder `tiny`
      - `ref.fa`: 2 human proteins
      - `other.fa`: a selected subset of proteins from 8 other mammalian
        species
      - `Makefile`: a longer makefile
      - `brm.pl`: a Perl script for finding ortholog groups and sorting
        them to folders

The `Makefile` runs the analysis in four stages. Stages 1,2 and 4 are
written in the Makefile, you have to finish stage 3.

  - If you run `make` without argument, it will attempt to run all 4
    stages, but stage 3 will not run, because it is missing
  - Stage 1: run as `make ref.brm`
      - It runs `blast` as in task A, then splits proteins into ortholog
        groups and creates one folder for each group with file `prot.fa`
        containing protein sequences
  - Stage 2: run as `make alignments`
      - In each folder with an ortholog group, it will create an
        alignment `prot.mfa`.
  - Stage 3: run as `make trees` (needs to be written by you)
      - In each folder with an ortholog group, it should create files
        `LG.treefile` and `JTT.treefile` containing the results of the
        `IQ-tree` program run with two different evolutionary models LG
        and JTT+G4.
      - Create a rule that will create `LG.treefile` from `prot.mfa` in
        one gene folder. Use `%` for the folder name, similarly as in
        the rules to make alignments. Within the rule, you can use `$*`
        variable to get the name of this folder.
      - Run IQ-tree by commands of the form:  
        `iqtree2 -redo --seqtype AA -s GENE_FOLDER/prot.mfa -m LG -o
        opossum --seed 42 --prefix GENE_FOLDER/LG -n 50`
      - Change `GENE_FOLDER` to the appropriate filename of the folder
        using `make` variables.
      - IQ-tree will create several output files starting with `LG` in
        the folder with the gene.
      - When this is done, create a similar rule except replace LG by
        JTT in the file names and change evolutionary model in the
        command by replacing `-m LG` option with `-m JTT+G4`.
      - Also add variables `LG_TREES` and `JTT_TREES` to the top of the
        Makefile listing filenames of all desirable trees and uncomment
        phony target `trees` which uses these variables.
  - Stage 4: run as `make consensus`
      - Output trees from stage 3 are concatenated for each model
        separately to files `lg/intree`, `jtt/intree` and then `phylip`
        is run to produce consensus trees `lg.tree` and `jtt.tree`
      - This stage also needs variables `LG_TREES` and `JTT_TREES` to be
        defined by you.

<!-- end list -->

  - Run your `Makefile` and check that the files `lg.tree` and
    `jtt.tree` are produced, as well as their ASCII-art "images"
    `lg.tree.txt` and `jtt.tree.txt`.
  - Instructions for submitting see after Task C (you can submit B even
    if you do not do C).

### Task C (adding statistics to Makefile)

IQ-tree also produced files named `LG.iqtree` and `JTT.iqtree` in each
gene folder. These contain various statistics about the run of the
program. We want to compare these values across genes and models, so we
want to extract them to two tables in csv format. Namely, we are
interested in two lines from the `*.iqtree` files:

  - Line starting "Log-likelihood of the tree" which gives a (negative)
    number saying how well the data fit the model. Higher number means a
    better fit. We can compare these numbers to see which model fits the
    data better.
  - Line starting "Total CPU time used" which gives computation time in
    seconds. We can see if the computation time is different for
    different models.

<!-- end list -->

  - Uncomment the line adding a new goal to the `Makefile` named
    `stats`.
  - This goal has two subgoals producing files `stats-time.tsv` and
    `stats-likelihood.tsv`.
  - Write a rule for each of these subgoals producing the desired file.

To gather appropriate lines from all files and also know which file they
come from, you can use grep command of the form  
`grep --with-filename '^Log-likelihood of the tree:' gene_Q*/*.iqtree`  
Its output will look like this:

    gene_Q6ZWJ1_human/JTT.iqtree:Log-likelihood of the tree: -4475.9510 (s.e. 121.3816)
    gene_Q6ZWJ1_human/LG.iqtree:Log-likelihood of the tree: -4648.0902 (s.e. 130.9257)
    gene_Q8WUG5_human/JTT.iqtree:Log-likelihood of the tree: -4097.1127 (s.e. 64.7212)
    gene_Q8WUG5_human/LG.iqtree:Log-likelihood of the tree: -4144.8778 (s.e. 67.7092)

You should reformat the output to `stats-likelihood.tsv` that looks like
this (the columns are separated with tabs `"\t"`):

    Q6ZWJ1_human    JTT -4475.9510
    Q6ZWJ1_human    LG  -4648.0902
    Q8WUG5_human    JTT -4097.1127
    Q8WUG5_human    LG  -4144.8778

  - To do reformatting, you can use perl one-liners or sed/awk directly
    in the Makefile or write your own script in Perl or Python and call
    it from Makefile.
  - If you write one-liners in Makefile, you have to replace `$` with
    `$$` (e.g. `$$F[0]` to get the first column in a Perl one-liner).

File `stats-time.tsv` should be similar, but it should contain time in
seconds in the third column as below. Your time measurements may differ.

    Q6ZWJ1_human    JTT 24.6512
    Q6ZWJ1_human    LG  6.47912
    Q8WUG5_human    JTT 28.7618
    Q8WUG5_human    LG  7.47675

### Submitting tasks B and C

  - **Submit** the whole folder `tiny` (using `cp -ri tiny
    /submit/make/username/`), including `Makefile`, scripts you wrote of
    task C (if any), all gene folders with tree files and the resulting
    combined trees and statistics files.

### Task D (running make, final obersvations)

  - Copy your `Makefile` and any scripts you wrote in tasks B and C to
    folder `small`, which contains 9 human proteins and run `make` on
    this slightly larger set.
      - Again, run it without `qsub`, but it will take some time,
        particularly if the server is busy
  - Look at the two resulting trees (`jtt.tree.txt`, `lg.tree.txt`)
      - Note that the two children of each internal node are equivalent,
        so their placement higher or lower in the figure does not
        matter.
      - Do the two trees differ from each other? If yes, how?
      - Branches of the tree contain a number called **support**
        indicating in how many of the individual gene trees this branch
        was found. Higher support means more reliable branch. What is
        the highest and lowest support for a branch in each tree?
      - Do your trees differ from the accepted "correct tree" shown
        below? If yes, how?
  - Run `make stats` and look at the resulting tsv files.
      - Which model produced higher likelihoods?
      - Which model runs faster?
  - Write **your observations to the protocol** and **submit** the
    entire `small` folder.

The correct tree extracted from a larger tree at the [UCSC genome
browser](https://genome-euro.ucsc.edu/images/phylo/hg38_100way.png):

``` 
                                          +-------human
                          +---------------|            
                          |               +-------baboon
                  +-------|    
                  |       |       +---------------rabbit   
                  |       +-------|            
                  |               |       +-------rat      
          +-------|               +-------|        
          |       |                       +-------guineapig
          |       |
  +-------|       |                       +-------pig
  |       |       +-----------------------|
  |       |                               +-------dog
  |       |
  |       +---------------------------------------elephant
  |
  +-----------------------------------------------opossum
```

### Further possibilities

Here are some possibilities for further experiments, in case you are
interested (do not submit these):

  - You could copy your extended `Makefile` to folder `large` and create
    trees for all ortholog groups in the big set.
      - This would take a long time, so submit it through qsub and only
        some time after the lecture is over to allow classmates to work
        on task A.
      - After `ref.brm` si done, programs for individual genes can be
        run in parallel, so you can try running `make -j 2` and request
        2 threads from `qsub`
  - IQ-tree also supports many other models (for more information, see
    [documentation](http://www.iqtree.org/doc/Substitution-Models)); you
    could try to play with those. Or run IQ-tree without `-m` when it
    tries to find the best model for your input.
  - We were looking at the trees in text mode but you can create nice
    figures of the trees using `figtree` program. It is available on
    vyuka, but you can also [install
    it](https://github.com/rambaut/figtree/releases) on your computer if
    interested.
  - Command `touch FILENAME` will change the modification time of the
    given file to the current time.
      - What happens when you run `touch` on some of the intermediate
        files in the analysis in task B? Does `Makefile` always run
        properly?

