---
title: HWbash
---

* TOC
{:toc}

[Lecture on Perl](./Lperl.md), [Lecture on command-line
tools](./Lbash.md)

  - In this set of tasks, use command-line tools or one-liners in Perl,
    awk or sed. Do not write any scripts or programs.
  - Your commands should work also for other input files with the same
    format (do not try to generalize them too much, but also do not use
    very specific properties of a particular input, such as the number
    of lines etc.)

### Preparatory steps and submitting

``` bash
# create a folder for this homework
mkdir bash
# move to the new folder
cd bash
# link input files to the current folder
ln -s /tasks/bash/human.fa /tasks/bash/dog.fa /tasks/bash/matches.tsv /tasks/bash/names.txt .
# copy protocol to the current folder
cp -i /tasks/bash/protocol.txt .
```

  - Now you can open `protocol.txt` in your favorite editor and start
    working.
  - Command `ln` created symbolic links (shortcuts) to the input files,
    so you can use them under names such as `human.fa` rather than full
    paths such as `/tasks/bash/human.fa`.

When you are done, you can **submit** all required files as follows
(substitute your username):

``` bash
cp -ipv protocol.txt human.txt pairs.txt similar.tsv best.txt function.txt passwords.csv /submit/bash/your_username

# check what was submitted
ls -l /submit/bash/your_username
```

### Introduction to tasks A-C

  - In these tasks we will again process bioinformatics data. We have
    two files of sequences in the FASTA format. This time the sequences
    represent proteins, not DNA, and therefore they use 20 different
    letters representing different amino acids. Lines starting with '\>'
    contain the identifier of a protein and potentially an additional
    description. This is followed by the sequence of this protein, which
    will not be needed in this task. This data comes from the
    [Uniprot](https://www.uniprot.org/) database.
  - File `/tasks/bash/dog.fa` is a FASTA file containing about 10% of
    randomly selected dog proteins. Each protein is identified in the
    FASTA file only by its ID such as `A0A8I3MJS8_CANLF`.
  - File `/tasks/bash/human.fa` is a FASTA file with all human proteins.
    Each ID is followed by a description of the biological function of
    the protein.
  - These two sets of proteins were compared by the bioinformatics tool
    called [BLAST](https://blast.ncbi.nlm.nih.gov/doc/blast-help/),
    which finds proteins with similar sequences. The results of BLAST
    are in file `/tasks/bash/matches.tsv`. This file contains a section
    for each dog protein. This section starts with several comments,
    i.e. lines starting with `#` symbol. This is followed by a table
    with the found matches in the `TSV` format, i.e., several values
    delimited by tab characters `\t`. We will be interested in the first
    two columns representing the IDs of the dog and human proteins,
    respectively.

### Task A (counting proteins)

**Steps (1) and (2)**

  - Use files `human.fa` and `dog.fa` to find out how many proteins are
    in each. Each protein starts with a line starting with the `>`
    symbol, so it is sufficient to count those.
  - Beware that `>` symbol means redirect in bash. Therefore you have to
    enclose it in single quotation marks `'>'` so that it is taken
    literally.
  - For each file write a single command or a pipeline of several
    commands that will produce the number with the answer. Write the
    commands and the resulting protein counts to the appropriate
    sections of your **protocol**.

**Step (3)**

  - Create file `human.txt` which contains sequence IDs and descriptions
    extracted from `human.fa`. This file will be used in Task C.
  - Leading `>` should be removed. Any text after `OS=` in the
    description should be also removed.
  - This file should be sorted alphabetically.
  - The file should start as follows:

<!-- end list -->

    1433B_HUMAN 14-3-3 protein beta/alpha 
    1433E_HUMAN 14-3-3 protein epsilon 
    1433F_HUMAN 14-3-3 protein eta 
    1433G_HUMAN 14-3-3 protein gamma 
    1433S_HUMAN 14-3-3 protein sigma 

  - **Submit** file `human.txt`, write your commands to the
    **protocol**.

### Task B (counting matches)

**Step (1)**

  - From file `matches.tsv` extract pairs of similar proteins and store
    them in file `pairs.txt`.
  - Each line of the file should contain a pair of protein IDs extracted
    from the first two columns of the `matches.tsv` file.
  - These IDs should be separated by a single space and the file should
    be sorted alphabetically.
  - Do not forget to omit lines with comments.
  - Each pair from the input should be listed only once in the output.
  - Commands `grep`, `sort` and `uniq` would be helpful. To select only
    some columns, you can use commands `cut`, `awk` or a Perl one-liner.
  - The file `pairs.txt` should have 18939 lines (verify using command
    `wc`) and it should start as follows:

<!-- end list -->

    A0A1Y6D565_CANLF P_HUMAN
    A0A1Y6D565_CANLF S13A4_HUMAN
    A0A222YTD8_CANLF S39A4_HUMAN

  - **Submit** file `pairs.txt` and write your commands to the
    **protocol**.

**Step (2)**

  - Find out how many dog proteins have at least one similarity found in
    `matches.tsv`. This can be done by counting distinct values in the
    first column of your `pairs.txt` file from step (1).
  - We suggest commands `cut/awk/perl`, `sort`, `uniq`, `wc`
  - The result of your commands should be an output consisting of a
    single number (and the end-of-line character).
  - Write your answer and commands to the **protocol**. What percentage
    is this number out of all dog proteins found in Task A(2)? (You may
    compute the percentage manually by a calculator).

**Step (3)**

  - The third column of `matches.tsv` (the first numerical column after
    the two protein IDs) contains a number between 0 and 100. This is
    the percentage of amino acids that are the same between the two
    proteins.
  - Create a file which will contains only those lines of `matches.tsv`
    that have this number at least 90, i.e. where fewer than 10% of
    amino acids mutated to something else. Omit also comment lines.
    Leave the order of lines as in the original file.
  - Write the result to `similar.tsv`
  - The file `similar.tsv` should have 1056 lines and it should start as
    follows:

<!-- end list -->

    A0A8I3MMG4_CANLF    FKBP3_HUMAN 97.321  224 6   0   1   224 1   224 4.83e-163   448
    A0A8I3NRH9_CANLF    KIF15_HUMAN 94.045  403 24  0   7   409 7   409 0.0 818
    A0A8I3P3E9_CANLF    TRAK1_HUMAN 97.065  954 27  1   1   954 1   953 0.0 1900

  - **Submit** file `similar.tsv` and write your commands to the
    **protocol**.

### Task C (joining information)

**Step (1)**

  - For each dog protein, the first (top) match in `matches.tsv`
    represents the strongest similarity.
  - In this step, we want to extract such strongest match for each dog
    protein which has at least one match.
  - The result should be a file `best.txt` listing the two IDs separated
    by a space. The file should be sorted by the **second column**
    (human protein ID).
  - The file should start as follows:

<!-- end list -->

    A0A8I3MVQ9_CANLF 1433E_HUMAN
    A0A8I3MT06_CANLF 1433G_HUMAN
    A0A8I3QRX3_CANLF 1433T_HUMAN

  - This task can be done by printing the lines that are not comments
    but follow a comment line starting with `#`.
  - In a Perl one-liner, you can create a state variable which will
    remember if the previous line was a comment and based on that you
    decide if you print the current line.
  - Instead of using Perl, you can play with `grep`. Option `-A 1`
    prints the matching lines as well as one line after each match and
    separates blocks of consecutive lines by `--`.
  - **Submit** file `best.txt` with the result and write your commands
    to the **protocol**.

**Step (2):**

  - Now we want to extend file `best.txt` with a description of each
    human protein.
  - Since similar proteins often have similar functions, this will allow
    somebody studying dog proteins to learn something about their
    possible functions based on similarity to well-studied human
    proteins.
  - To achieve this, we join together file `best.txt` from step 1 and
    `human.txt` created in Task A(3). Conveniently, they are both sorted
    by the ID of the human protein.
  - Use command
    [join](http://www.gnu.org/software/coreutils/manual/html_node/join-invocation.html)
    to join these files.
  - Use option `-1 2` to use the second column of `best.txt` as a key
    for joining.
  - The output of `join` may start as follows:

<!-- end list -->

    1433E_HUMAN A0A8I3MVQ9_CANLF 14-3-3 protein epsilon 
    1433G_HUMAN A0A8I3MT06_CANLF 14-3-3 protein gamma 
    1433T_HUMAN A0A8I3QRX3_CANLF 14-3-3 protein theta 

  - Further reformat the output so that the dog ID goes first (e.g.
    `A0A8I3MVQ9_CANLF`), followed by human protein ID (e.g.
    `1433E_HUMAN`), followed by the rest of the text.
  - Sort by dog protein ID, store in file `function.txt`.
  - The output should start as follows:

<!-- end list -->

    A0A1Y6D565_CANLF P_HUMAN P protein
    A0A222YTD8_CANLF S39AA_HUMAN Zinc transporter ZIP10
    A0A5F4CW23_CANLF ELA_HUMAN Apelin receptor early endogenous ligand

  - Files `best.txt` and `function.txt` should have the same number of
    lines.
  - Which human protein is the best match for the dog protein
    `A0A8I3RVG4_CANLF` and what is its function?
  - **Submit** file `best.txt`. Write your commands and the answer to
    the question above to your **protocol**.

### Task D (passwords)

  - The file `/tasks/bash/names.txt` contains data about several people,
    one per line.
  - Each line consists of given name(s), surname and email separated by
    spaces.
  - Each person can have multiple given names (at least 1), but exactly
    one surname and one email. Email is always of the form
    `username@uniba.sk`.
  - The task is to generate file `passwords.csv` which contains a
    randomly generated password for each of these users
      - The output file should have columns separated by commas ','
      - The first column should contain username extracted from email
        address, the second column surname, the third column all given
        names and the fourth column the randomly generated password.
  - **Submit** file `passwords.csv` with the result of your commands.
    Write your commands to the **protocol**.

Example line from input:

    Pavol Orszagh Hviezdoslav hviezdoslav32@uniba.sk

Example line from output (password will differ):

    hviezdoslav32,Hviezdoslav,Pavol Orszagh,3T3Pu3un

Hints:

  - Passwords can be generated using `pwgen` (e.g. `pwgen -N 10 -1`
    prints 10 passwords, one per line).
  - We also recommend using `perl`, `wc`, `paste` (check option `-d` in
    `paste`) and backtick operator \`\`.
  - In Perl, function
    [`pop`](http://perldoc.perl.org/functions/pop.html) may be useful
    for manipulating `@F` and function
    [`join`](http://perldoc.perl.org/functions/join.html) for connecting
    strings with a separator.

