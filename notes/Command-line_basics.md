---
title: Command-line basics
---

* TOC
{:toc}

This a brief tutorial for students who are not familiar with Linux
command-line.

## Files and folders

  - Images, texts, data, etc. are stored in files.
  - Files are grouped in folders (directories) for better organization.
  - A folder can also contain other folders, forming a tree structure.

### Moving around folders (ls, cd)

  - One folder is always selected as the current one; it is shown on the
    command line
  - The list of files and folders in the current folder can be obtained
    with the `ls` command
  - The list of files in some other folder can be obtained with the
    command `ls other_folder`
  - The command `cd new_folder` changes the current folder to the
    specified new folder
  - Notes: `ls` is an abbreviation of "list", `cd` is an abbreviation of
    "change directory"

**Example:**

  - When we login to the server, we are in the folder `/home/username`.
  - We then execute several commands listed below
  - Using `cd` command, we move to folder `/tasks/perl/` (the computer
    does not print anything, only changes the current folder).
  - Using `ls` command, we print all files in the `/tasks/perl/` folder.
  - Finally we use `ls /tasks` command to print the folders in /tasks

<!-- end list -->

``` bash
username@vyuka:~$ cd /tasks/perl/
username@vyuka:/tasks/perl$ ls
fastq-lengths.pl  reads-small.fastq  reads-tiny-trim1.fastq  series.tsv
protocol.txt      reads-tiny.fasta   reads-tiny-trim2.fastq
reads.fastq       reads-tiny.fastq   series-small.tsv
username@vyuka:/tasks/perl$ ls /tasks
bash  bioinf1  bioinf2  bioinf3  cloud  flask  make  perl  python  r1  r2
```

### Absolute a relative paths

  - **Absolute path** determines how to get to a given file or folder
    from the **root** of the whole filesystem.
  - For example `/tasks/perl/`, `/tasks/perl/series.tsv`,
    `/home/username` etc.
  - Individual folders are separated by a slash `/` in the path.
  - Absolute paths start with a slash `/`.

<!-- end list -->

  - **Relative path** determines how to get to a given file or folder
    from the current folder.
  - For example, if the current folder is `/tasks/perl/`, the relative
    path to file `/tasks/perl/series.tsv` is simply `series.tsv`
  - If the current folder is `/tasks/`, the relative path to file
    `/tasks/perl/series.tsv` is `perl/series.tsv`
  - Relative paths do not start with a slash.
  - A relative path can also go "upwards" to the containing folder using
    `..`
  - For example, if the current folder is `/tasks/perl/`, the relative
    path `..` will give us the same as `/tasks` and `../../home` will
    give us `/home`

Commands `ls`, `cd` and others accept both relative and absolute paths.

### Important folders

  - **Root** is the folder with absolute path `/`, the starting point of
    the tree structure of folders.
  - **Home directory** with absolute path `/home/username` is set as the
    current folder after login.
      - Users typically store most of their files within their home
        directory and its subfolders, if there is no good reason to
        place them elsewhere.
      - Tilde `~` is an abbreviation for your home directory. For
        example `cd ~` will place you there.

### Wildcards

  - We can use wildcards to work with only selected files in a folder.
  - For example, all files starting with letter x in the current folder
    can be printed as `ls x*`
  - The star represents any number of characters in the filename.
  - All files containing letter x anywhere in the name can be printed as
    `ls *x*`

### Examining file content (less)

  - Type `less filename`
  - This will print the first page of the file on your screen. Then you
    can move around the file using space or keys Page up and Page down.
    You can quit the viewer pressing letter `q` (abbreviation of quit).
    Help with additional keys is accessed by pressing `h` (abbreviation
    of help).
  - If you have a short file and want to just print it all on your
    screen, use `cat filename`
  - Try for example the following commands:

<!-- end list -->

``` bash
less /tasks/perl/reads-small.fastq  # move around the file, then press q
cat /tasks/perl/reads-tiny.fasta    # see the whole file on the screen
```

## Organizing files and folders

### Creating new folders (mkdir)

  - To create a new folder (directory), use a command of the form `mkdir
    new_folder_path`
  - The path to the new folder can be relative or absolute
  - For example, assume that we are in the home folder, the following
    two commands both create a new folder called test and folder test2
    within it.

<!-- end list -->

``` bash
mkdir test
# change the next command according to your username
mkdir /home/username/test/test2  
```

### Copying files (cp)

  - To copy files, use a command of the form `cp source destination`
  - This will copy file specified as the source to the destination.
  - Both source and destination can be specified via absolute or
    relative paths.
  - The destination can be a folder into which the file is copied or an
    entire name of the copied file.
  - We can also copy several files to the same folder as follows: `cp
    file1 file2 file3 destination`

**Example:** Let us assume that the current directory is
`/home/username` and that directories `test` and `test2` were created as
above. The following will copy file `/tasks/perl/reads-small.fastq` to
the new directory test and afterwards also to the current folder (which
is the home directory). In the third step it will be copied again to the
current folder under a new name `test.fastq`. In the final steps it will
be copied to the `test` directory under this new name as well.

``` bash
# change the next command according to your username
# this copies an existing file to the home directory using absolute paths
cp /tasks/perl/reads-small.fastq /home/username/
# now we use relative paths to copy the file from home to the new folder called test
cp reads-small.fastq test/
# now the file is copied within current folder under a new filename test.fastq
cp reads-small.fastq test.fastq
# change directory to test
cd test
# copy the file again from the home directory to the test directory under name test.fastq
cp ../test.fastq .
# we can copy several files to a different folder
cp test.fastq reads-small.fastq test2/
```

### Other file-related commands (cp -r, mv, rm, rmdir)

  - Copying whole folders can be done via `cp -r source destination`
  - While using `cp`, it is good to add `-i` option which will warn us
    in case we are going to overwrite some existing file. For example:

<!-- end list -->

``` bash
cd ~
cp -i reads-small.fastq test/
```

  - To move files to a new folder or rename them, you can use `mv`
    command, which works similarly to `cp`, i.e. you specify first
    source, then destination. Option -i can be used here as well.
  - Command `rm` will delete specified files, `rm -r` whole folders (be
    very careful\!).
  - An empty folder can be deleted using `rmdir`

## Beware: be very careful on the command-line

  - The command-line will execute whatever you type, it generally does
    not ask for confirmation, even for dangerous actions.
  - You can very easily remove or overwrite some important file by
    mistake.
  - There is no undo.
  - Therefore always check your command before pressing Enter. Use `-i`
    option for `cp`, `mv`, and possibly even `rm`.

## File permissions and other properties

  - Linux gives us control over which files we share and which we keep
    private.
  - Each file (and folder) has its owner (usually the user who created
    it) and a group of users it is assigned to.
  - It has three level of permissions: for its owner (abbreviated u, as
    user), for its group (g) and for every user on the system (o, as
    other).
  - At each level, we can grant the right to read the file (abbreviated
    r), to write or modify it (abbreviated w) and to execute the file
    (abbreviated x).
  - Permission to execute is important for executable programs but also
    for folders.

### The long form of ls command

  - The `ls` command can be run with switch `-l` to produce a more
    detailed information about files
  - Here are two lines from the output after running `ls -l /tasks/`

<!-- end list -->

``` bash
drwxr-xr-x 2 bbrejova users    4096 Feb 11 22:43 perl
drwxrwxr-x 5 bbrejova teacher  4096 Mar  7  2022 make
```

  - The very first character of each line is `d` for folders
    (directories) and `-` for regular files. Here we see two folders.
  - The next three characters give permissions for the user, the next
    three for the group and the next three of other users. For example
    folder `perl` has all three permissions `rwx` for the user, and all
    permissions except writing for group and others.
  - Column 3 and 4 of the output list the owner and the group assigned
    to the file.
  - Column 5 lists the size (by default in bytes; this can be changed to
    human-readable sizes, such as gigabytes, using `-h` switch)
  - Finally the line contains the date of the last modification of the
    file and its name.

### Changing file permissions

  - File permissions can be changed using `chmod` command.
  - It is followed by change specification in the form of `[who][+ or
    -][which rights]`
  - Part `[who]` can be `o` (others), `g` (group), `u` (user), `a` (all
    = user+group+others)
  - Sign `+` means adding rights, sign `-` means removing them
  - Rights can be `w` (write), `r` (read), `x` (execute)
  - There are also many other possibilities, see
    [documentation](https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html)

<!-- end list -->

``` bash
# add read permission to others for file protocol.txt:
chmod o+r protocol.txt
# remove write permissions from others and group for file protocol.txt:
chmod og-w protocol.txt
# add read permissions to everybody for whole folder "data" and its files and subfolders
chmod -r a+r data
```

## See also

  - [Linux tutorial](http://tldp.org/LDP/gs/node5.html)

