---
title: Lperl
---

* TOC
{:toc}

This lecture is a brief introduction to the Perl scripting language. We
recommend revisiting necessary parts of this lecture while working on
the exercises.

Homework: [HWperl](./HWperl.md)

## Why Perl

  - Very popular in 1990s and early 2000s for system scripting, also
    very popular in bioinformatics.
  - Probably not many of you know this language, so a good training to
    learn a new language quickly.

Advantages

  - It has good capabilities for processing text files, regular
    expressions, running external programs etc. (Perl-style regular
    expression today used in many languages).
  - It is closer to common programming languages than shell scripts.
  - Perl one-liners on the command line can replace many other tools
    such as sed and awk (the next lecture).

Disadvantages

  - It has quirky syntax.
  - It is easy to write very unreadable programs (Perl is sometimes
    joking called write-only language)
  - It is quite slow and uses a lot of memory. If possible, do not read
    the entire input to memory, process line by line.

We will use Perl 5, Perl 6 is quite a different language.

## Hello world

It is possible to run the code directly from a command line (more
later):

``` bash
perl -e'print "Hello world\n"'
```

This is equivalent to the following code stored in a file:

``` perl
#! /usr/bin/perl -w
use strict;
print "Hello world!\n";
```

  - The first line is the path to the interpreter.
  - Switch `-w` switches warnings on, e.g. if we manipulate with an
    undefined value (equivalent to `use warnings;`)
  - The second line `use strict` will switch on a more strict syntax
    checks, e.g. all variables must be defined.
  - Use of `-w` and `use strict` is strongly recommended.

Running the script

  - Store the program in a file `hello.pl`
  - Make it executable (`chmod a+x hello.pl`)
  - Run it with command `./hello.pl`
  - It is also possible to run as `perl hello.pl` (e.g. if we don't have
    the path to the interpreter in the file or the executable bit is not
    set).

## The first input file for today: TV series

  - [IMDb](https://www.imdb.com/) is an online database of movies and TV
    series with user ratings.
  - We have downloaded a preprocessed dataset of selected TV series
    ratings from [GitHub](https://github.com/nazareno/imdb-series/).
  - From this dataset, we have selected only several series with a high
    number of voting users.

<!-- end list -->

  - Each line of the file contains data about one episode of one series.
    Columns are tab-separated and contain the name of the series, the
    name of the episode, the global index of the episode within the
    series, the number of the season, the index of the episode with the
    season, rating of the episode and the number of voting users.
  - Here is a smaller version of this file with only six lines:

<!-- end list -->

    Black Mirror    The National Anthem 1   1   1   7.8 35156
    Black Mirror    Fifteen Million Merits  2   1   2   8.2 35317
    Black Mirror    The Entire History of You   3   1   3   8.6 35266
    Game of Thrones Winter Is Coming    1   1   1   9   27890
    Game of Thrones The Kingsroad   2   1   2   8.8 21414
    Game of Thrones Lord Snow   3   1   3   8.7 20232

  - The smaller and the larger version of this file can be found at our
    server under filenames `/tasks/perl/series-small.tsv` and
    `/tasks/perl/series.tsv`

## A sample Perl program

For each series (column 0 of the file) we want to compute the number of
episodes.

``` perl
#! /usr/bin/perl -w
use strict;

#associative array (hash), with series name as key
my %count;  

while(my $line = <STDIN>) {  # read every line on input
    chomp $line;    # delete end of line, if any

    # split the input line to columns on every tab, store them in an array
    my @columns = split "\t", $line;  

    # check input - should have 7 columns
    die "Bad input '$line'" unless @columns == 7;

    my $series = $columns[0];

    # increase the counter for this series
    $count{$series}++;
}

# write out results, series sorted alphabetically
foreach my $series (sort keys %count) {
    print $series, " ", $count{$series}, "\n";
}
```

This program does the same thing as the following one-liner (more on
one-liners in the next lecture):

``` bash
perl -F'"\t"' -lane 'die unless @F==7; $count{$F[0]}++;
  END { foreach (sort keys %count) { print "$_ $count{$_}" }}' filename
```

When we run it for the small six-line input, we get the following
output:

    Black Mirror 3
    Game of Thrones 3

## The second input file for today: DNA sequencing reads (fastq)

  - DNA sequencing machines can read only short pieces of DNA called
    reads.
  - Reads are usually stored in [FASTQ
    format](https://en.wikipedia.org/wiki/FASTQ_format).
  - Files can be very large (gigabytes or more), but we will use only a
    small sample from bacteria *Staphylococcus aureus* (data from the
    [GAGE
    website](http://gage.cbcb.umd.edu/data/Staphylococcus_aureus/Data.original/)).
  - Each read is stored in 4 lines:
      - line 1: ID of the read and other description, line starts with
        @,
      - line 2: DNA sequence, A,C,G,T are bases (nucleotides) of DNA, N
        means unknown base,
      - line 3: +
      - line 4: quality string, which is the string of the same length
        as DNA in line 2. ASCII code of each character represents
        quality of one base in DNA, where higher quality means lower
        probability of a sequencing error.  
        Details (not needed today): If *p* is the probability that this
        base is wrong, the quality string will contain character with
        ASCII value 33+(-10 log *p*), where log is the decimal
        logarithm. Character `!` (ASCII 33) means probability 1 of
        error, character `$` (ASCII 36) means 50% error, character `+`
        (ASCII 43) is 10% error, character `5` (ASCII 53) is 1% error.
  - Our file has all reads of equal length (this is not always the
    case).
  - Technically, a single read and its quality can be split into
    multiple lines, but this is rarely done, and we will assume that
    each read takes 4 lines as described above.

The first 4 reads from file `/tasks/perl/reads-small.fastq` (trimmed to
50 bases for better readability):

    @SRR022868.1845/1
    AAATTTAGGAAAAGATGATTTAGCAACATTTAGCCTTAATGAAAGACCAG
    +
    IICIIIIIIIIIID%IIII8>I8III1II,II)I+III*II<II,E;-HI
    @SRR022868.1846/1
    TAGCGTTGTAAAATAAATTTCTAGAATGGAAGTGATGATATTGAAATACA
    +
    4CIIIIIIII52I)IIIII0I16IIIII2IIII;IIAII&I6AI+*+&G5

## Variables, types

### Scalar variables

  - The names of scalar variables start with `$`
  - Scalar variables can hold undefined value (`undef`), string, number,
    reference etc.
  - Perl converts automatically between strings and numbers

<!-- end list -->

``` bash
perl -e'print((1 . "2")+1, "\n")'
# 13
perl -e'print(("a" . "2")+1, "\n")'
# 1
perl -we'print(("a" . "2")+1, "\n")'
# Argument "a2" isn't numeric in addition (+) at -e line 1.
# 1
```

  - If we switch on strict parsing, each variable needs to be defined by
    `my`
      - Several variables can be created and initialized as follows: `my
        ($a,$b) = (0,1);`
  - Usual set of C-style
    [operators](http://perldoc.perl.org/perlop.html), power is `**`,
    string concatenation `.`
  - Numbers compared by `<, <=, ==, !=` etc., strings by `lt, le, eq,
    ne, gt, ge`
  - Comparison operator `$a cmp $b` for strings, `$a <=> $b` for
    numbers: returns -1 if `$a<$b`, 0 if they are equal, +1 if `$a>$b`

### Arrays

  - Names start with `@`, e.g. `@a`
  - Access to element 0 in array `@a`: `$a[0]`
      - Starts with `$`, because the expression as a whole is a scalar
        value
  - Length of array `scalar(@a)`. In scalar context, `@a` is the same
    thing.
      - e.g. `for(my $i=0; $i<@a; $i++) { ... }` iterates over all
        elements
  - If using non-existent indexes, they will be created, initialized to
    `undef` (`++, +=` treat `undef` as 0)
  - Command `foreach` iterates through values of an array (values can be
    changed during iteration):

<!-- end list -->

``` perl
my @a = (1,2,3);
foreach my $val (@a) {  # iterate through all values
    $val++;             # increase each value in array by 1
}
```

Other useful commands

  - Stack/vector using functions `push` and `pop`: `push @a, (1,2,3); $x
    = pop @a;`
  - Analogically `shift` and `unshift` on the left end of the array
    (slower)
  - Sorting
      - `@a = sort @a;` (sorts alphabetically)
      - `@a = sort {$a <=> $b} @a;` (sorts numerically)
      - `{ }` can contain an arbitrary comparison function, `$a` and
        `$b` are the two compared elements
  - Array concatenation `@c = (@a,@b);`
  - Swap values of two variables: `($x,$y) = ($y,$x);`

### Hash tables (associative array, dictionaries, maps)

  - Names start with `%`, e.g. `%b`
  - Keys are strings, values are scalars.
  - Access element with key `"X"`: `$b{"X"}`
  - Write out all elements of associative array `%b`:

<!-- end list -->

``` perl
foreach my $key (keys %b) {
    print $key, " ", $b{$key}, "\n";
}
```

  - Initialization with a constant: `%b = ("key1" => "value1", "key2" =>
    "value2");`
  - Test for existence of a key: `if(exists $a{"X"}) {...}`

### Multidimensional arrays, fun with pointers

  - Pointer to a variable (scalar, array, dictionary): `\$a, \@a, \%a`
  - Pointer to an anonymous array: `[1,2,3]`, pointer to an anonymous
    hash: `{"key1" => "value1"}`
  - Hash of lists is stored as hash of pointers to lists:

<!-- end list -->

``` perl
my %a = ("fruits" => ["apple","banana","orange"],
         "vegetables" => ["tomato","carrot"]);
$x = $a{"fruits"}[1];
push @{$a{"fruits"}}, "kiwi";
my $aref = \%a;
$x = $aref->{"fruits"}[1];
```

  - Module <Data::Dumper> has function `Dumper`, which recursively
    prints complex data structures (good for debugging)

## Strings

  - Substring:
    [`substr`](http://perldoc.perl.org/functions/substr.html)`($string,
    $start, $length)`
      - Used also to access individual characters (use length 1)
      - If we omit `$length`, extracts suffix until the end of the
        string, negative `$start` counts from the end of the string,...
      - We can also replace a substring by something else:
        `substr($str, 0, 1) = "aaa"` (replaces the first character by
        "aaa")
  - Length of a string:
    [`length`](http://perldoc.perl.org/functions/length.html)`($str)`
  - Splitting a string to parts:
    [`split`](http://perldoc.perl.org/functions/split.html)` 
    reg_expression, $string, $max_number_of_parts `
      - If `" "` is used instead of regular expression, splits at any
        whitespace
  - Connecting parts to a string
    [`join`](http://perldoc.perl.org/functions/join.html)`($separator,
    @strings)`
  - Other useful functions:
    [`chomp`](http://perldoc.perl.org/functions/chomp.html) (removes the
    end of line),
    [`index`](http://perldoc.perl.org/functions/index.html) (finds a
    substring), `lc`, `uc` (conversion to lower-case/upper-case),
    `reverse` (mirror image),

### Formatted printing

  - You can use command
    [`printf`](http://perldoc.perl.org/functions/printf.html) to print
    formatted data, such as specifying the number of decimal places,
    column width etc.
  - Similarly
    [`sprintf`](http://perldoc.perl.org/functions/sprintf.html) creates
    a formatted string.
  - The first argument is a formatting string which can contain
    arbitrary static text + special placeholders such as `%d` for
    integers, `%f` for real numbers (floating point), and `%s` for
    strings.
  - The following arguments then specify values to be substituted for
    placeholders.

<!-- end list -->

``` perl
my $i=42;       # variable with integer value
my $x=3.1415;   # variable with floating-point value
my $s="hello";  # variable with a string

# print each variable to a column of with 10
# value x will be printed to one decimal place 
printf("%10d %10.1f %10s\n", $i, $x, $s); 
```

## Regular expressions

  - Regular expressions are a powerful tool for working with strings,
    now featured in many languages
  - Here only a few examples, more details can be found in [the official
    tutorial](http://perldoc.perl.org/perlretut.html)

<!-- end list -->

``` perl
if($line =~ /hello/) {  
   print "line contains word hello as a substring";
}
if($line =~ /hello/i) {  # ignore letter case, also finds Hello, HELLO, hElLo
   print "line contains word hello as a substring regardless of ltter case";
}
if($line =~ /hello.*world/) {  # . is any character, * means any number of repeats
   print "line contains word hello later followed by word world";
}
if($line =~ /hello\s+world/) {  # \s is whitespace, + means at least one repeat
   print "line contains words hello and word sepearted by whitespace";
}

# editting strings
$line =~ s/\s+$//;      # remove whitespace at the end of the line
$line =~ s/[0-9]+/X/g;  # replace each sequence of numbers with character X 
                        # (final g means the rule is repeated as many times as applicable)
$line =~ s/^./X/;       # the first character on a line is changed to X
                        # (^ means start of line, . means any character)
$line =~ s/\///g;       # each slash '/' is removed 
                        # (since / deliminates parts of the s operator, use \/
$line =~ tr/ab/xy/;     # replace each 'a' with 'x', each 'b' with 'y' 

# if the line starts with >,
# store the word following > (until the first whitespace)
# and store it in variable $name 
# (\S means non-whitespace),
# the string matching part of expression in (..) is stored in $1
if($line =~ /^\>(\S+)/) { $name = $1; }
```

## Conditionals, loops

``` perl
if(expression) {  # () and {} cannot be omitted
   commands
} elsif(expression) {
   commands
} else {
   commands
}

command if expression;   # here () not necessary
command unless expression;
# good for checking inputs etc
die "negative value of x: $x" unless $x >= 0;

for(my $i=0; $i<100; $i++) {
   print $i, "\n";
}

foreach my $i (0..99) {
   print $i, "\n";
}

my $x = 1;
while(1) {
   $x *= 2;
   last if $x >= 100;
}
```

Undefined value, number 0 and strings `""` and `"0"` evaluate as false,
but we recommend always explicitly using logical values in conditional
expressions, e.g. `if(defined $x)`, `if($x eq "")`, `if($x==0)` etc.

## Input, output

``` perl
# Reading one line from standard input
$line = <STDIN>
# If no more input data available, returns undef


# The special idiom below reads all the lines from input until the end of input is reached:
while (my $line = <STDIN>) {
   # commands processing $line ...
}
```

  - See also [on Perl I/O
    operators](http://perldoc.perl.org/perlop.html#I%2fO-Operators%7Cmanual)
  - Output to stdout through
    [`print`](http://perldoc.perl.org/functions/print.html) or
    [`printf`](http://perldoc.perl.org/functions/printf.html) commands

## Sources of Perl-related information

  - Man pages (included in ubuntu package `perl-doc`), also available
    online at <http://perldoc.perl.org/>
      - `man perlintro` introduction to Perl
      - `man perlfunc` list of standard functions in Perl
      - `perldoc -f split` describes function split, similarly other
        functions
      - `perldoc -q sort` shows answers to commonly asked questions
        (FAQ)
      - `man perlretut` and `man perlre` regular expressions
      - `man perl` list of other manual pages about Perl
  - Various web tutorials e.g. [this
    one](http://www.perl.com/pub/a/2000/10/begperl1.html)
  - Books
      - [Simon Cozens: Beginning
        Perl](http://www.perl.org/books/beginning-perl/) freely
        downloadable
      - [Larry Wall et al: Programming
        Perl](http://oreilly.com/catalog/9780596000271/) classics, Camel
        book

## Further optional topics

For illustration, we briefly cover other topics frequently used in Perl
scripts (these are not needed to solve the exercises).

### Opening files

``` perl
my $in;
open $in, "<", "path/file.txt" or die;  # open file for reading
while(my $line = <$in>) {
  # process line
}
close $in;

my $out;
open $out, ">", "path/file2.txt" or die; # open file for writing
print $out "Hello world\n";
close $out;
# if we want to append to a file use the following instead:
# open $out, ">>", "cesta/subor2.txt" or die;

# standard files
print STDERR "Hello world\n";
my $line = <STDIN>;
# files as arguments of a function
read_my_file($in);
read_my_file(\*STDIN);
```

### Working with files and directories

Module <File::Temp> allows to create temporary working directories or
files with automatically generated names. These are automatically
deleted when the program finishes.

``` perl
use File::Temp qw/tempdir/;
my $dir = tempdir("atoms_XXXXXXX", TMPDIR => 1, CLEANUP => 1 ); 
print STDERR "Creating temporary directory $dir\n";
open $out,">$dir/myfile.txt" or die;
```

Copying files

``` perl
use File::Copy;
copy("file1","file2") or die "Copy failed: $!";
copy("Copy.pm",\*STDOUT);
move("/dev1/fileA","/dev2/fileB");
```

Other functions for working with file system, e.g. `chdir, mkdir,
unlink, chmod,` ...

Function `glob` finds files with wildcard characters similarly as on
command line (see also `opendir, readdir`, and <File::Find>`  module `)

``` perl
ls *.pl
perl -le'foreach my $f (glob("*.pl")) { print $f; }'
```

Additional functions for working with file names, paths, etc. in modules
<File::Spec> and <File::Basename>.

Testing for an existence of a file (more in [perldoc -f
-X](http://perldoc.perl.org/functions/-X.html))

``` perl
if(-r "file.txt") { ... }  # is file.txt readable?
if(-d "dir") {.... }       # is dir a directory?
```

### Running external programs

Using the `system` command

  - It returns -1 if it cannot run command, otherwise returns the return
    code of the program

<!-- end list -->

``` perl
my $ret = system("command arguments");
```

Using the backtick operator with capturing standard output to a variable

  - This does not tests the return code

<!-- end list -->

``` perl
my $allfiles = `ls`;
```

Using pipes (special form of open sends output to a different command,
or reads output of a different command as a file)

``` perl
open $in, "ls |";
while(my $line = <$in>) { ... }
```

``` perl
open $out, "| wc"; 
print $out "1234\n"; 
close $out;
# output of wc:
#      1       1       5
```

### Command-line arguments

``` perl
# module for processing options in a standardized way
use Getopt::Std;
# string with usage manual
my $USAGE = "$0 [options] length filename

Options:
-l           switch on lucky mode
-o filename  write output to filename
";

# all arguments to the command are stored in @ARGV array
# parse options and remove them from @ARGV
my %options;
getopts("lo:", \%options);
# now there should be exactly two arguments in @ARGV
die $USAGE unless @ARGV==2;
# process options
my ($length, $filenamefile) = @ARGV;
# values of options are in the %options array
if(exists $options{'l'}) { print "Lucky mode\n"; }
```

For long option names, see module Getopt::Long

### Defining functions

``` perl
sub function_name {
  # arguments are stored in @_ array
  my ($firstarg, $secondarg) = @_;
  # do something
  return ($result, $second_result);
}
```

  - Arrays and hashes are usually passed as references:
    `function_name(\@array, \%hash);`
  - It is advantageous to pass very long string as references to prevent
    needless copying: `function_name(\$sequence);`
  - References need to be dereferenced, e.g. `substr($$sequence)` or
    `$array->[0]`

### Bioperl

A large library useful for bioinformatics. This snippet translates DNA
sequence to a protein using the standard genetic code:

``` perl
use Bio::Tools::CodonTable;
sub translate
{
    my ($seq, $code) = @_;
    my $CodonTable = Bio::Tools::CodonTable->new( -id => $code);
    my $result = $CodonTable->translate($seq);

    return $result;
}
```

