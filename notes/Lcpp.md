---
title: Lcpp
---

* TOC
{:toc}

[HWcpp](./HWcpp.md)

## Combination of C++ and Python

Python is a very flexible language with many libraries, but programs in
Python can be slow and take a lot of memory compared with programs
written for example in C++. In this lecture we will see how to combine
C++ and Python so that you write core algorithmic parts in C++ but use
Python to do other less time-sensitive computations, such as parsing
inputs. We will be using [pybind11
library](https://pybind11.readthedocs.io/en/stable/basics.html#creating-bindings-for-a-simple-function)
to do that.

Here is an example C++ code, which can be converted to a module and used
in Python. The code should be stored in file `example_module.cc`

```cpp
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <vector>
#include <string>

using std::vector;
using std::string;

class ExampleClass {
    // An example class which will have a counter
    // of total length of strings encoutered

    // variable holding the counter
    int counter_ = 0;

public:
    // empty constructor
    ExampleClass() {}

    // a method which gets a vector of strings,
    // adds their lengths to the counter
    // and returns the value of the counter
    int add_lengths(vector<string> strings) {
        for (auto &one_string: strings) {
            counter_ += one_string.size();
        }
        return counter_;
    }
};


// This is the code for binding to Python
// every class and method you want to export, must be declared here
PYBIND11_MODULE(example_module, m) {
    m.doc() = "pybind11 example module"; // optional module docstring

    pybind11::class_<ExampleClass>(m, "ExampleClass")
        // constructor
        .def(pybind11::init())
        // member function
        .def("add_lengths", &ExampleClass::add_lengths);
}
```

We can then compile this code to be used as Python module:

``` bash
c++ -O3 -Wall -shared -std=c++11 -fPIC $(python3 -m pybind11 --includes) example_module.cc -o example_module$(python3-config --extension-suffix)
```

If there are no errors, this will create binary file
`example_module.cpython-310-x86_64-linux-gnu.so` (the suffix may
differ). We can now import and use this module in Python. We need to be
in the same directory as the compiled output.

``` Python
import example_module

# create class instance
c = example_module.ExampleClass()
# add two strings and print counter
print(c.add_lengths(["aaa", "bb"]))
# add no strings and print counter
print(c.add_lengths([]))
# add one string and print counter
print(c.add_lengths(["x"]))
```

**Data types**

  - Note that pybind11 automatically converts function arguments and
    return values between C++ data types and Python data types.
  - This is done by creating a copy of the data, so it is relatively
    slow.
  - It is also possible to create Python wrappers for C++ types and C++
    wrappers around Python types to avoid this conversion, see the
    [documentation](https://pybind11.readthedocs.io/en/stable/advanced/cast/overview.html#conversion-table)
    (not needed here).

## Measuring running time and memory

In the homework, we will compare pure Python implementation with that
based on C++ in terms of time and memory. A simple way to measure the
time and memory of a process is to use `/usr/bin/time` command.

Assume we have a script `memory.py` which appends 10 million integers to
a list:

    a = []
    for i in range(10 ** 7):

Here we run it using the time command in verbose mode and get several
lines of output when the command is done:

    /usr/bin/time -v python3 memory.py 
        Command being timed: "python3 memory.py"
        User time (seconds): 1.29
        System time (seconds): 1.04
        Percent of CPU this job got: 99%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:02.34
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 400728
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 98963
        Voluntary context switches: 1
        Involuntary context switches: 10
        Swaps: 0
        File system inputs: 0
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0

  - **User time** is CPU time spent on computation in user mode while
    **system time** is CPU time spent in kernel mode, e.g. to read a
    file or allocate a memory. **Wall clock time** measures the actual
    time from start to end of execution.
  - In the homework, we will for simplicity use the wall clock time.
    However keep in mind that it does not take into account the
    following issues.
      - It does not count the number of CPUs used by multithreaded
        applications, which will not be relevant in this homework.
      - It includes the time that your process waits for available
        resources (CPUs etc.). If the server is busy with other
        processes, your wall clock time might be inflated. Therefore
        also check the row **Percent of CPU this job got**. If this
        number of close to 100%, your job was not waiting much.
        Otherwise redo your experiment at a time when the server is less
        busy.
  - In the example above, CPU usage was 99%, with 1.29s in user time and
    1.04 in system time. The sum of these two is 2.33s, which is indeed
    close to wall clock 2.34s.
  - We will also look at **maximum resident set size** which is the
    maximum memory used by your process during its execution (in
    kilobytes).

For easier parsing, you can also specify a **format**; see documentation
in `man time` and this example:

    /usr/bin/time --format="%e %M %P" python3 memory.py
    2.03 400692 99%

