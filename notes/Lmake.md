---
title: Lmake
---

* TOC
{:toc}

[HWmake](./HWmake.md)

## Job scheduling

  - Some computing jobs take a lot of time: hours, days, weeks,...
  - We do not want to keep a command-line window open the whole time;
    therefore we run such jobs in the background
  - Simple commands to do it in Linux:
      - To run the program immediately, then switch the whole console to
        the background:
        [screen](https://www.gnu.org/software/screen/manual/screen.html),
        [tmux](https://tmux.github.io/) (see a [separate
        section](./Screen.md))
      - To run the command when the computer becomes idle:
        [batch](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/batch.html)
  - Now we will concentrate on **[Sun Grid
    Engine](https://en.wikipedia.org/wiki/Oracle_Grid_Engine)**, a
    complex software for managing many jobs from many users on a cluster
    consisting of multiple computers
  - Basic workflow:
      - Submit a job (command) to a queue
      - The job waits in the queue until resources (memory, CPUs, etc.)
        become available on some computer
      - The job runs on the computer
      - Output of the job is stored in files
      - User can monitor the status of the job (waiting, running)
  - Complex possibilities for assigning priorities and deadlines to
    jobs, managing multiple queues etc.
  - Ideally all computers in the cluster share the same environment and
    filesystem

<!-- end list -->

  - We have a simple training cluster for this exercise:
      - You submit jobs to queue on vyuka
      - They will run on computers runner01 and runner02
      - This cluster is only temporarily available until the next Monday

### Submitting a job (qsub)

Basic command: `qsub -b y -cwd command 'parameter < input > output 2>
error'`

  - quoting around command parameters allows us to include special
    characters, such as `<, >` etc. and not to apply it to `qsub`
    command itself
  - `-b y` treats command as binary, usually preferable for both binary
    programs and scripts
  - `-cwd` executes command in the current directory
  - `-N` name allows to set name of the job
  - `-l resource=value` requests some non-default resources
  - for example, we can use `-l threads=2` to request 2 threads for
    parallel programs
  - Grid engine will not check if you do not use more CPUs or memory
    than requested, be considerate (and perhaps occasionally watch your
    jobs by running top at the computer where they execute)
  - `qsub` will create files for `stdout` and `stderr`, e.g. `s2.o27`
    and `s2.e27` for the job with name `s2` and jobid 27

### Monitoring and deleting jobs (qstat, qdel)

Command `qstat` displays jobs of the current user

  - job 28 is running of server runner02 (status <t>r</tt>), job 29 is
    waiting in queue (status `qw`)

<!-- end list -->

``` 
job-ID  prior   name       user         state submit/start at     queue       
---------------------------------------------------------------------------------
     28 0.50000 s3         bbrejova     r     03/15/2016 22:12:18 main.q@runner02
     29 0.00000 s3         bbrejova     qw    03/15/2016 22:14:08             
```

  - Command `qstat -u '*'` displays jobs of all users.
  - Finished jobs disappear from the list.
  - Command `qstat -F threads` shows how many threads available:

<!-- end list -->

``` 
queuename                      qtype resv/used/tot. load_avg arch          states
---------------------------------------------------------------------------------
main.q@runner01                BIP   0/1/2          0.00     lx26-amd64    
    hc:threads=1
    238 0.25000 sleeper.pl bbrejova     r     03/05/2020 13:12:28     1        
---------------------------------------------------------------------------------
main.q@runner02                BIP   0/1/2          0.00     lx26-amd64    
    237 0.75000 sleeper.pl bbrejova     r     03/05/2020 13:12:13     1        
```

  - Command `qdel` deletes a job (waiting or running)

### Interactive work on the cluster (qrsh), screen

Command `qrsh` creates a job which is a normal interactive shell running
on the cluster

  - In this shell you can manually run commands
  - When you close the shell, the job finishes
  - Therefore it is a good idea to run `qrsh` within `screen` command
      - Run `screen` command, this creates a new shell
      - Within this shell, run `qrsh`, then whatever commands on the
        rmeote server
      - By pressing `Ctrl-a d` you "detach" the screen, so that both
        shells (local and `qrsh`) continue running but you can close
        your local window
      - Later by running `screen -r` you get back to your shells
      - See more details in the [separate section](./screen.md)

### Running many small jobs

For example, we many need to run some computation for each human gene
(there are roughly 20,000 such genes). Here are some possibilities:

  - Run a script which iterates through all jobs and runs them
    sequentially
      - Problems: This does not use parallelism, needs more programming
        to restart after some interruption
  - Submit processing of each gene as a separate job to cluster
    (submitting done by a script/one-liner)
      - Jobs can run in parallel on many different computers
      - Problem: Queue gets very long, hard to monitor progress, hard to
        resubmit only unfinished jobs after some failure.
  - Array jobs in `qsub` (option `-t`): runs jobs numbered 1,2,3...;
    number of the current job is in an environment variable, used by the
    script to decide which gene to process
      - Queue contains only running sub-jobs plus one line for the
        remaining part of the array job.
      - After failure, you can resubmit only unfinished portion of the
        interval (e.g. start from job 173).
  - Next: using `make` in which you specify how to process each gene and
    submit a single `make` command to the queue
      - Make can execute multiple tasks in parallel using several
        threads on the same computer (`qsub` array jobs can run tasks on
        multiple computers)
      - It will automatically skip tasks which are already finished, so
        restart is easy

## Make

[Make](https://en.wikipedia.org/wiki/Make_\(software\)) is a system for
automatically building programs (running compiler, linker etc)

  - In particular, we will use [GNU
    make](https://www.gnu.org/software/make/manual/)
  - Rules for compilation are written in a file typically called
    `Makefile`
  - Rather complex syntax with many features, we will only cover basics

### Rules

  - The main part of a `Makefile` are rules specifying how to generate
    target files from some source files (prerequisites).
  - For example the following rule generates file `target.txt` by
    concatenating files `source1.txt` and `source2.txt`:

<!-- end list -->

``` make
target.txt : source1.txt source2.txt
      cat source1.txt source2.txt > target.txt
```

  - The first line describes target and prerequisites, starts in the
    first column
  - The following lines list commands to execute to create the target
  - Each line with a command starts with a **tab** character

<!-- end list -->

  - If we have a directory with this rule in file called `Makefile` and
    files `source1.txt` and `source2.txt`, running `make target.txt`
    will run the `cat` command
  - However, if `target.txt` already exists, the command will be run
    only if one of the prerequisites has more recent modification time
    than the target
  - This allows to restart interrupted computations or rerun necessary
    parts after modification of some input files
  - `make` automatically chains the rules as necessary:
      - If we run `make target.txt` and some prerequisite does not
        exist, `make` checks if it can be created by some other rule and
        runs that rule first.
      - In general it first finds all necessary steps and runs them in
        appropriate order so that each rules has its prerequisites
        ready.
      - Option `make -n target` will show which commands would be
        executed to build target (dry run) - good idea before running
        something potentially dangerous.

### Pattern rules

We can specify a general rule for files with a systematic naming scheme.
For example, to create a `.pdf` file from a `.tex` file, we use the
`pdflatex` command:

``` make
%.pdf : %.tex
      pdflatex $^
```

  - In the first line, `%` denotes some variable part of the filename,
    which has to agree in the target and all prerequisites.
  - In commands, we can use several variables:
      - Variable `$^` contains the names of the prerequisites (source).
      - Variable `$@` contains the name of the target.
      - Variable `$*` contains the string matched by `%`.

### Other useful tricks in Makefiles

#### Variables

Store some reusable values in variables, then use them several times in
the `Makefile`:

``` make
MYPATH := /projects/trees/bin

target : source
       $(MYPATH)/script < $^ > $@
```

#### Wildcards, creating a list of targets from files in the directory

The following `Makefile` automatically creates `.png` version of each
`.eps` file simply by running `make`:

``` make
EPS := $(wildcard *.eps)
EPSPNG := $(patsubst %.eps,%.png,$(EPS))

all:  $(EPSPNG)

clean:
        rm $(EPSPNG)

%.png : %.eps
        convert -density 250 $^ $@
```

  - Variable `EPS` contains names of all files matching `*.eps`.
  - Variable `EPSPNG` contains names of desired `.png` files.
      - It is created by taking filenames in `EPS` and changing `.eps`
        to `.png`
  - `all` is a "phony target" which is not really created
      - Its rule has no commands but all `.png` files are prerequisites,
        so are done first.
      - The first target in a `Makefile` (in this case `all`) is default
        when no other target is specified on the command-line.
  - `clean` is also a phony target for deleting generated `.png` files.
  - Thus run `make all` or just `make` to create png files, `make clean`
    to delete them.

#### Useful special built-in target names

Include these lines in your `Makefile` if desired

``` make
.SECONDARY:
# prevents deletion of intermediate targets in chained rules

.DELETE_ON_ERROR:
# delete targets if a rule fails
```

### Parallel make

Running make with option `-j 4` will run up to 4 commands in parallel if
their dependencies are already finished. This allows easy
parallelization on a single computer.

## Alternatives to Makefiles

  - Bioinformaticians often uses "pipelines" - sequences of commands run
    one after another, e.g. by a script or `make`
  - There are many tools developed for automating computational
    pipelines in bioinformatics, see e.g. this review: [Jeremy Leipzig;
    A review of bioinformatic pipeline frameworks. Brief
    Bioinform 2016.](https://academic.oup.com/bib/article/doi/10.1093/bib/bbw020/2562749/A-review-of-bioinformatic-pipeline-frameworks)
  - For example [Snakemake](https://snakemake.readthedocs.io/en/stable/)
      - Snake workflows can contain shell commands or Python code
      - Big advantage compared to `make`: pattern rules may contain
        multiple variable portions (in `make` only one `%` per filename)
      - For example, assume we have several FASTA files and several
        profiles (HMMs) representing protein families and we want to run
        each profile on each FASTA file:

<!-- end list -->

    rule HMMER:
         input: "{filename}.fasta", "{profile}.hmm"
         output: "{filename}_{profile}.hmmer"
         shell: "hmmsearch --domE 1e-5 --noali --domtblout {output} {input[1]} {input[0]}"

## Overall advantages of using command-line one-liners and make

  - Compared to popular Python frameworks, such as Pandas, many
    command-line utilities process files line-by-line and thus do not
    need to load big files into memory.
  - For small easy tasks (e.g. counting lines, looking occurrences of a
    specific string, looking at first lines of the file etc.) it might
    be less effort to run a simple one-liner than to open the file in
    some graphical interface (Jupyter notebook, Excel) and finding the
    answer. This is true provided that you take time to learn
    command-line utilities.
  - Command-line commands, scripts and makefiles can be easily run in
    background on your computer or even on remote servers.
  - It is easy to document what exactly was run by keeping log of
    executed commands as well as any scripts used in the process.

