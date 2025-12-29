---
title: Lbash
---

* TOC
{:toc}

[HWbash](./HWbash.md)

This lecture introduces command-line tools and Perl one-liners.

  - We will do simple transformations of text files using command-line
    tools without writing any scripts or longer programs.

When working on the exercises, record all the commands used.

  - We strongly recommend making a log of commands for data processing
    also outside of this course.
  - If you have a log of executed commands, you can easily execute them
    again by copy and paste.
  - For this reason any comments are best preceded in the log by `#`.
  - If you use some sequence of commands often, you can turn it into a
    script.

## Efficient use of the Bash command line

Some tips for bash shell:

  - Use *tab* key to complete command names, path names etc.
      - Tab completion [can be
        customized](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html).
  - Use *up* and *down* keys to walk through the history of recently
    executed commands, then edit and execute the chosen command.
  - Press *ctrl-r* to search in the history of executed commands.
  - At the end of s session, history stored in `~/.bash_history`.
  - Command `history -a` appends history to this file right now.
      - You can then look into the file and copy appropriate commands to
        your log.
      - For example, print the last commands using `tail
        ~/.bash_history`
  - Various other history tricks exist, e.g. special variables
    [1](http://samrowe.com/wordpress/advancing-in-the-bash-shell/).
  - `cd -` goes to previously visited directory (also see `pushd` and
    `popd`).
  - `ls -lt | head` shows 10 most recent files, useful for seeing what
    you have done last in a folder.

Instead of bash, you can use more advanced command-line environments,
e.g. [iPhyton notebook](http://ipython.org/notebook.html).

## Redirecting and pipes

``` bash
# redirect standard output to file
command > file

# append to file
command >> file

# redirect standard error
command 2>file

# redirect file to standard input
command < file

# do not forget to quote > in other uses, 
# e.g. when searching for string ">" in a file dog.fa
grep '>' dog.fa
# (without quotes rewrites dog.fa)
# other special characters, such as ;, &, |, # etc
# should be quoted in '' as well

# send stdout of command1 to stdin of command2 
# this is called a pipeline
command1 | command2

# backtick operator executes command, 
# removes trailing \n from stdout, 
# substitutes to command line
# the following commands do the same thing:
head -n 2 file
head -n `echo 2` file

# redirect a string in ' ' to stdin of command head
head -n 2 <<< 'line 1
line 2
line 3'

# in some commands, file argument can be taken from stdin
# if denoted as - or stdin or /dev/stdin
# the following compares uncompressed version of names2.txt with names.txt
zcat names2.txt.gz | diff - names.txt 
# to create names2.txt.gz, we can take for example the first 5 lines of names.txt
head -n 5 names.txt | gzip -c > names2.txt.gz
```

Make piped commands fail properly:

``` bash
set -o pipefail
```

If set, the return value of a pipeline is the value of the last
(rightmost) command to exit with a non-zero status, or zero if all
commands in the pipeline exit successfully. This option is disabled by
default, the pipeline then returns exit status of the rightmost command.

## Text file manipulation

### Commands echo and cat (creating and printing files)

``` bash
# print text Hello and end of line to stdout
echo "Hello" 
# interpret backslash combinations \n, \t etc:
echo -e "first line\nsecond\tline"
# concatenate several files to stdout
cat file1 file2
```

### Commands head and tail (looking at start and end of files)

``` bash
# print 10 first lines of file (or stdin)
head file
some_command | head 
# print the first 2 lines
head -n 2 file
# print the last 5 lines
tail -n 5 file
# print starting from line 100 (line numbering starts at 1)
tail -n +100 file
# print lines 81..100
head -n 100 file | tail -n 20 
```

Documentation:
[head](http://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html),
[tail](http://www.gnu.org/software/coreutils/manual/html_node/tail-invocation.html)

### Commands wc, ls -lh, od (exploring file statistics and details)

``` bash
# prints three numbers:
# the number of lines (-l), number of words (-w), number of bytes (-c)
wc file

# prints the size of file in human-readable units (K,M,G,T)
ls -lh file

# od -a prints file or stdin with named characters 
#   allows checking whitespace and special characters
echo "hello world!" | od -a
# prints:
# 0000000   h   e   l   l   o  sp   w   o   r   l   d   !  nl
# 0000015
```

Documentation:
[wc](http://www.gnu.org/software/coreutils/manual/html_node/wc-invocation.html),
[ls](http://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html),
[od](http://www.gnu.org/software/coreutils/manual/html_node/od-invocation.html)

### Command grep (getting lines matching a regular expression)

``` bash
# get all lines in file human.fa containing string wall
grep wall human.fa
# -i ignores case (upper case and lowercase letters are the same)
grep -i wall human.fa
# -c counts the number of matching lines in each file in the current folder
grep -c '^[IJ]' *

# other options (there is more, see the manual):
# -v print/count non-matching lines (inVert)
# -n show also line numbers
# -B 2 -A 1 print 2 lines before each match and 1 line after match
# -E extended regular expressions (allows e.g. |)
# -F no regular expressions, set of fixed strings
# -f patterns in a file 
#    (good for selecting e.g. only lines matching one of "good" ids)
```

Documentation: [grep](http://www.gnu.org/software/grep/manual/grep.html)

### Commands sort, uniq

``` bash
# sort lines of a file alphabetically
sort names.txt

# some useful options of sort:
# -g numeric sort
# -k which column(s) to use as key
# -r reverse (from largest values)
# -t fields separator

# sorting output of the first command
# first compare column 3 numerically reversed (-k3,3gr),
# in case of ties use column 1 (-k1,1)
# the long result is piped to less to look at manually
grep -v '#' matches.tsv | sort -k3,3gr -k1,1 | less

# uniq outputs one line from each group of consecutive identical lines
# uniq -c adds the size of each group as the first column
# the following finds all unique lines
# and sorts them by frequency from the most frequent
sort protocol.txt | uniq -c | sort -gr
```

Documentation:
[sort](http://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html),
[uniq](http://www.gnu.org/software/coreutils/manual/html_node/uniq-invocation.html)

### Commands diff, comm (comparing files)

Command
[`diff`](http://www.gnu.org/software/coreutils/manual/html_node/diff-invocation.html)
compares two files. It is good for manual checking of differences.
Useful options:

  - `-b` (ignore whitespace differences)
  - `-r` for recursively comparing whole directories
  - `-q` for fast checking for identity
  - `-y` show differences side-by-side

Command
[`comm`](http://www.gnu.org/software/coreutils/manual/html_node/comm-invocation.html)
compares two sorted files. It is good for finding set intersections and
differences. It writes three columns:

  - lines occurring only in the first file
  - lines occurring only in the second file
  - lines occurring in both files

Some columns can be suppressed with options `-1, -2, -3`

### Commands cut, paste, join (working with columns)

  - Command
    [`cut`](http://www.gnu.org/software/coreutils/manual/html_node/cut-invocation.html)
    selects only some columns from file (perl/awk more flexible)
  - Command
    [`paste`](http://www.gnu.org/software/coreutils/manual/html_node/paste-invocation.html)
    puts two or more files side by side, separated by tabs or other
    characters
  - Command
    [`join`](http://www.gnu.org/software/coreutils/manual/html_node/join-invocation.html)
    is a powerful tool for making joins and left-joins as in databases
    on specified columns in two files

### Commands split, csplit (splitting files to parts)

  - Command
    [`split`](http://www.gnu.org/software/coreutils/manual/html_node/split-invocation.html)
    splits into fixed-size pieces (size in lines, bytes etc.)
  - Command
    [`csplit`](http://www.gnu.org/software/coreutils/manual/html_node/csplit-invocation.html)
    splits at occurrence of a pattern. For example, splitting a FASTA
    file into individual sequences:

<!-- end list -->

``` bash
csplit sequences.fa '/^>/' '{*}'
```

## Programs sed and awk

Both `sed` and `awk` process text files line by line, allowing to do
various transformations.

  - Program `awk` is newer, more advanced.
  - We will not cover these, several examples are shown below.
  - More info on [awk](https://en.wikipedia.org/wiki/AWK),
    [sed](https://en.wikipedia.org/wiki/Sed) on Wikipedia

<!-- end list -->

``` bash
# replace text "Chr1" by "Chromosome 1"
sed 's/Chr1/Chromosome 1/'
# prints the first two lines, then quits (like head -n 2)
sed 2q  

# print the first and second column from a file
awk '{print $1, $2}' 

# print the line if the difference between the first and second column > 10
awk '{ if ($2-$1>10) print }'  

# print lines matching pattern
awk '/pattern/ { print }' 

# count the lines (like wc -l)
awk 'END { print NR }'
```

## Perl one-liners

Instead of sed and awk, we will cover Perl one-liners.

  - More examples can be found on various websites, e.g.
    [2](https://learnbyexample.github.io/learn_perl_oneliners/one-liner-introduction.html)
  - Documentation for [Perl
    switches](http://perldoc.perl.org/perlrun.html)

<!-- end list -->

``` bash
# -e executes commands
perl -e 'print 2+3,"\n"'
perl -e '$x = 2+3; print $x, "\n"';

# -n wraps commands in a loop reading lines from stdin
# or files listed as arguments
# the following is roughly the same as cat:
perl -ne 'print'
# how to use:
perl -ne 'print' < names.txt > names3.txt
perl -ne 'print' names.txt names.txt > names-duplicated.txt
# Lines are stored in a special variable $_
# This variable is default argument of many functions, 
# including print, so print is the same as print $_

# simple grep-like commands:
perl -ne 'print if /pattern/'
perl -ne 'print if /^J/' names.txt
# simple regular expression modifications
perl -ne 's/TASK ([ABCD])/Task $1/; print' protocol.txt | less
# // and s/// are applied by default to $_

# -l removes end of line from each input line and adds "\n" after each print
# The following adds * at the end of each line:
perl -lne 'print $_, "*"' protocol.txt

# -a splits line into words separated by whitespace and stores them in array @F
# The next example prints difference in the numbers stored in columns 7 and 6.
# This is size of an interval which has start and end stored in these columns
grep -v '#' matches.tsv | perl -lane 'print $F[7]-$F[6]' | less

# -F allows to set separator used for splitting (regular expression)
# the next example splits at tabs
grep -v '#' matches.tsv | perl -F'"\t"' -lane 'print $F[7]-$F[6]' | less

# END { commands } is run at the very end, after we finish reading input
# the following example computes the average of interval lengths
grep -v '#' matches.tsv | perl -lane '$count++; $sum += $F[7]-$F[6]; END { print $sum/$count; }'
# similarly BEGIN { command } before we start
```

Other interesting possibilities:

``` bash
# -i replaces each file with a new transformed version (DANGEROUS!)
# the next example removes empty lines from all .txt files
# in the current directory
perl -lne 'print if length($_)>0' -i *.txt
# The following example replaces a sequence of whitespace by exactly one space 
# and removes leading and trailing spaces from lines in all .txt files
perl -lane 'print join(" ", @F)' -i *.txt

# Variable $. contains the line number, $ARGV the name of file or - for stdin
# the following prints filename and line number in front of every line
perl -ne'printf "%s.%d: %s", $ARGV, $., $_' names.txt protocol.txt  | less

# moving files *.txt to have extension .tsv:
#   first print commands 
#   then execute by hand or replace print with system
#   mv -i asks if something is to be rewritten
ls *.txt | perl -lne '$s=$_; $s=~s/\.txt$/.tsv/; print("mv -i $_ $s")'
ls *.txt | perl -lne '$s=$_; $s=~s/\.txt$/.tsv/; system("mv -i $_ $s")'
```

