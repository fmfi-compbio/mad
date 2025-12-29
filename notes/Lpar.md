---
title: Lpar
---

* TOC
{:toc}

Today we will work with the parallel computing framework Apache Beam.
Usually, we use these frameworks in cloud for computation over multiple
machines, but today we will run them locally.

## Apache beam

### Running locally

On your own machine, please install packages with

``` bash
pip install apache-beam
```

You are given basic template with comments in
`/tasks/par/example_job.py`

You can run it as follows:

``` bash
python3 example_job.py --output out --input "/tasks/par/dataset/splitaa"
```

This job uses one file and stores results into a file starting with name
out. You can change the name if you want. This is very useful for any
debugging.

The actual job just counts amount of each base in the input data (and
discards any fastq headers).

You can use parameter --input to use some input file from your harddrive
(or multiple files).

To run on multiple input files, you can do:

``` bash
python example_job.py --output out --input "/tasks/par/dataset/*"
```

To run using multiple CPU cores, you can do:

``` bash
python example_job.py --output out --input "/tasks/par/dataset/*" --direct_running_mode=multi_processing --direct_num_workers=4
```

This is the main part of the code:

``` python
 with beam.Pipeline(options=pipeline_options) as p:

# Read the text file[pattern] into a PCollection.
lines = p | 'Read' >> ReadFromText(known_args.input)

counts = (
    lines
    | 'Filter' >> beam.Filter(good_line)
    | 'Split' >> (beam.ParDo(WordExtractingDoFn()))
    | 'GroupAndSum' >> beam.CombinePerKey(sum))

# Format the counts into a PCollection of strings.
def format_result(word, count):
  return '%s: %d' % (word, count)

output = counts | 'Format' >> beam.MapTuple(format_result)

# Write the output using a "Write" transform that has side effects.
output | 'Write' >> WriteToText(known_args.output)
```

First, we create a PCollection (think of it as a distributed, unordered
collection of elements, similar to an array but without meaningful
indices). Then we apply various Beam transforms over it.

  - Read: We use ReadFromText to load lines from a text file. Each line
    becomes an element in the PCollection.
  - Filter: The beam.Filter transform is used to remove unwanted data
    early. It takes a function (in our case, good\_line) and keeps only
    the elements for which the function returns True. Here,
    good\_line(line) checks if a line contains only valid genome
    characters (A, C, G, or T). Lines that don't match are discarded.
  - ParDo: The beam.ParDo transform is a powerful and flexible way to
    process each element individually (or produce multiple outputs from
    a single input). Here, we use a custom DoFn (WordExtractingDoFn),
    which for each line emits multiple (character, 1) pairs —
    essentially "splitting" the line into individual letters and tagging
    each with a count of 1. Important difference between Map and ParDo:
    beam.Map produces exactly one output per input. beam.ParDo can emit
    zero, one, or many outputs per input. This makes ParDo suitable for
    more complex transformations, like splitting, filtering inside a
    DoFn, or emitting multiple records from a single input.
  - CombinePerKey: After we have a lot of (character, 1) pairs, we need
    to combine them: count how many times each character appeared.
    beam.CombinePerKey(sum) does exactly this: it groups all elements by
    key (the character) and applies a combining function (here, Python’s
    built-in sum) to the associated values. So if there are ten (A, 1)
    pairs, they get combined into one (A, 10).
  - MapTuple (Format): We then format the results into a human-readable
    string using beam.MapTuple. It takes the key and the value and
    formats them as "character: count".
  - Write: Finally, the formatted strings are written to a text file
    using WriteToText.

A few additional important notes:

Apache Beam is not just a library for running a pipeline in a linear
fashion. It defines the pipeline structure, but the actual execution is
deferred. Beam can optimize and parallelize the computation under the
hood, possibly splitting it across multiple machines and processing
elements concurrently.

Transformations like Filter, ParDo, and CombinePerKey are lazy: they
build up the pipeline graph but don't actually execute until the
pipeline is run.

You might want to check out more examples [at beam
documentation](https://beam.apache.org/documentation/transforms/python/elementwise/map/).

## Tips

  - If you run code locally, you can use print in processing functions
    (e.g. inside WordExtractionFN::process)
  - CombinePerKey requires called function to be associative and
    commutative. If you want something more complicated look at
    averaging example 5 here:
    <https://beam.apache.org/documentation/transforms/python/aggregation/combineperkey/>

## Running in cloud

If you are interested (this is not necessary for the homework), you can
try running Apache Beam in the cloud. Most cloud providers provide free
credits for students. You have the following options:

  - [Azure](https://azure.microsoft.com/en-us/free/students). You need
    to store files in Blob storage and then use Apache Spark in Azure
    HDInsight.
  - [GCP](https://cloud.google.com/free?hl=en). You need to store files
    in Google cloud storage and then use Dataflow.

