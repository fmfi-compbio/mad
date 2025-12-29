---
title: Lcloud
---

* TOC
{:toc}

Today we will work with [Google Cloud](https://cloud.google.com/) (GCP),
which is a cloud computing platform. GCP contains many services (virtual
machines, kubernetes, storage, databases, ...). We are mainly interested
in Dataflow and Storage. Dataflow allows highly parallel computation on
large datasets. We will use an educational account which gives you a
certain amount of resources for free.

## Basic setup

You should have received instructions how to create GCloud account and
get cloud credits via email. You should be able to login to google cloud
console.

Now:

  - Login to some Linux machine (ideally vyuka)
  - If the machine is not vyuka, install gcloud command-line package (we
    recommend via
    [snap](https://cloud.google.com/sdk/docs/downloads-snap)).
  - Run the following command to initialize and authorize your GCloud
    configuration:

<!-- end list -->

``` bash
gcloud init --console-only
```

  - Follow the instructions (copy the provided link to your browser,
    login and then copy code back to the console).

## Input files and data storage

Today we will use [Gcloud storage](https://cloud.google.com/storage) to
store input and output files. Think of it as some limited external disk.
You can just upload and download files, no random access to the middle
of the file.

Run the following two commands to check if you can see the "bucket"
(data storage) associated with this lecture:

``` bash
# the following command should give you a big list of files
gsutil ls gs://fmph-mad-2024-public/

# this command downloads one file from the bucket
gsutil cp gs://fmph-mad-2024-public/splitaa splitaa

# the following command prints the file in your console 
# (no need to do this).
gsutil cat gs://fmph-mad-2024-public/splitaa
```

You should also create your own bucket (storage area). Pick your own
name, must be <b>globally</b> unique:

``` bash
gsutil mb gs://mysuperawesomebucket
```

If you get "AccessDeniedException: 403 The billing account for the
owning project is disabled in state absent", you should open project in
web UI (console.cloud.google.com), head to page Billing -\> Link billing
account and select "XY for Education".

## Apache beam and Dataflow

We will be using Apache Beam in this session (because Pyspark stinks).

## Running locally

If you want to use your own machine, please install packages with

``` bash
pip install 'apache-beam[gcp]'
```

You are given basic template with comments in
`/tasks/cloud/example_job.py`

You can run it locally as follows:

First run (this is needed just once):

``` bash
gcloud auth application-default login --no-launch-browser
```

Then:

``` bash
python3 example_job.py --output out
```

This job downloads one file from cloud storage and stores it into file
starting with name out. You can change the name if you want. This is
very useful for any debugging.

The actual job just counts amount of each base in the input data (and
discards any fastq headers).

You can even use parameter --input to use some input file from your
harddrive.

## Running in Dataflow

Now you can run Beam job in Dataflow on small sample:

``` bash
python3 example_job.py --output gs://YOUR_BUCKET/out/outxy --region europe-west1 --runner DataflowRunner --project PROJECT_ID --temp_location gs://YOUR_BUCKET/temp/ --input gs://fmph-mad-2024-public/splitaa
```

You can find PROJECT\_ID using:

``` bash
gcloud projects list
```

You will probably get an error like:

``` bash
Dataflow API has not been used in project XYZ before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/dataflow.googleapis.com/overview?project=XYZ then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
```

Visit the URL (from you error, not from this lecture) and click enable
API, then run command again.

If you get an error containing: ZONE\_RESOURCE\_POOL\_EXHAUSTED, try
changing region to us-east1 or some other region from
<https://cloud.google.com/compute/docs/regions-zones#available>.

You can then download output using:

``` bash
gsutil cp gs://YOUR_BUCKET/out/outxy* .
```

Now you can run job on full dataset (this is what you should be doing in
homework):

``` bash
python3 example_job.py --output gs://YOUR_BUCKET/out/outxy --region europe-west1 --runner DataflowRunner --project PROJECT_ID --temp_location gs://YOUR_BUCKET/temp/ --input gs://fmph-mad-2024-public/* --num_workers 5 --worker_machine_type n2-standard-4
```

If you want to watch progress:

  - Go to web console. Find dataflow in the menu (or type it into search
    bar), and go to jobs and select your job.
  - If you want to see machines magically created, go to VM Instances.

## Apache beam

This is the relevant part of the code:

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
    # pylint: disable=expression-not-assigned
    output | 'Write' >> WriteToText(known_args.output)
```

First we create a collection of data (thing about it as a big array,
where indices are not significant). Then we apply various beam functions
over it. First we filter it to keep only good lines, then we extract
relevant parts of line (we emit (c, 1) for each letter c) and then we
group results by key (first part of the tuple) and sum values (second
part of the tuple).

Note that this is just template for the job. Beam decides what part of
computation is run where and parallelizes things automatically.

One might ask what is the difference between ParDo and Map. Map only
outputs one element per one input. ParDo can output as many as it wants.

You might want to check out more examples [at beam
documentation](https://beam.apache.org/documentation/transforms/python/elementwise/map/).

## Tips

  - First run your code locally. It is much faster to iterate. Only if
    you are satisfied with the result, run it in cloud on full dataset.
  - If you run code locally, you can use print in processing functions
    (e.g. inside WordExtractionFN::process)
  - CombinePerKey requires called function to be associative and
    commutative. If you want something more complicated look at
    averaging example 5 here:
    <https://beam.apache.org/documentation/transforms/python/aggregation/combineperkey/>

