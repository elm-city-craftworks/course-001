## Part 1: Standard I/O streams and the file system

The article we'll work through in this part of the 
course is [Building Unix-style command line
applications](https://practicingruby.com/articles/building-unix-style-command-line-applications).
Reading it carefully should prepare you to work through the following questions
and exercises.

## Questions

> NOTE: Most of these questions can directly be answered by reading 
> the article, but a few might require you to search the web for
> answers. External research is not only OK, it's encouraged!

* What steps are involved in making a Ruby scripts runnable as a 
command line utility? (i.e. directly runnable like `rake` or `gem`
rather than having to type `ruby my_script.rb`)

* What is `ARGF` stream used for in Ruby?

* What is `$?` used for in Bash/Ruby?

* What does an exit status of zero indicate when a command line script 
terminates? How about a non-zero exit status?

* What is the difference between the `STDOUT` and `STDERR` output streams?

* When executing shell commands from within a Ruby script, how can you capture
what gets written to `STDOUT`? How do you go about capturing both `STDOUT` and
`STDERR` streams?

* How can you efficiently write the contents of an input file 
to `STDOUT` with empty lines omitted? Being efficient in this context
means avoiding storing the full contents of the input file in memory 
and processing the stream in a single pass.

* How would you go about parsing command line arguments that contain a mixture
of flags and file arguments? (i.e. something like `ls -a -l foo/*.txt`)

* What features are provided by Ruby's `String` class to help with fixed width
text layouts? (i.e. right aligning a column of numbers, or left aligning a
column of text with some whitespace after it to keep the total 
column width uniform)

* Suppose your script encounters an error and has to terminate itself. What is
the idiomatic Unix-style way of reporting that the command did not run
successfully?

## Exercises

> NOTE: The supporting materials for these exercises are in `samples/part1`.

In the "Building Unix-style command-line applications" article, we walked
through implementing a Ruby clone of the Unix `cat` utility. In this set of
exercises, you'll repeat a similar process to build a minimal clone of
the `ls` command. By doing so, you'll explore many of Ruby's capabilities
for working with files.

**STEP 1:** Run the following bash commands in the `data` folder and copy the 
output into a text file for future reference.

```bash
$ ls
$ ls foo/*.txt
$ ls -l
$ ls -a
$ ls -a -l
$ ls -l foo/*.txt
$ ls missingdir
$ ls -Z
```

**STEP 2:** Get the test harness in `ls_tests.rb` to pass its first test.
The script in `bin/ruby-ls` is a wrapper around the system `ls`
utility, so you should only need to add it to your shell's path in order
to get your first test passing. On a successful run, you should expect to
see the following output:

```
Test 1: OK
Next step: add a test for ruby-ls foo/*.txt
```

**STEP 3:** Now replace the `ruby-ls` script with a Ruby-based implementation 
that passes the first test.

**STEP 4:** Work your way through implementing some or all of the other use cases
listed in step 1. Start by adding an acceptance test, then implement
the correct behavior in the `ruby-ls` script. For ideas on how to write your tests, see
the [RCat acceptance tests](https://gist.github.com/sandal/1293709) from the assigned article.

**STEP 5:** If you didn't already check for exit codes for successful and unsuccessful
uses of the `ruby-ls` command, add a test for them now and then implement
command termination behavior that matches how `ls` works on your system.

*If you get stuck and have questions about this exercise, file a ticket in our
Github tracker. If you'd like a code review, please submit a pull request with
your solution. Feel free to submit stuff that is still a work-in-progress!*
