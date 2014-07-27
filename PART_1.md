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

**Q1:** What steps are involved in making a Ruby scripts runnable as a 
command line utility? (i.e. directly runnable like `rake` or `gem`
rather than having to type `ruby my_script.rb`)
A shebang line needs to be placed above the ruby code in a script that points to the location of the ruby environment,
in order to execute the script. #! /usr/bin/env ruby

**Q2:** What is `ARGF` stream used for in Ruby?
Is used in a Ruby script to process files that are passes in as command line arguments. It works in conjunction with ARGV so when a file is read from ARGF it is removed from the ARGV array,

**Q3:** What is `$?` used for in Bash/Ruby?
It is a global variable in Ruby that returns information about a Process's status. It is an instance of the Process::Status class.


**Q4:** What does an exit status of zero indicate when a command line script 
terminates? How about a non-zero exit status?
Zero indicates that there were no errors in the execution, while a non zero exit status indicates the error and I would think a well designed command line script would have some meaning to various non-zero values. 

**Q5:** What is the difference between the `STDOUT` and `STDERR` output streams?
STDOUT is a stream to print non-error related messages to, for instance puts prints to standard out.  STDERR is the
output stream for errors, so raise "Some message" would print to STDERR.

**Q6:** When executing shell commands from within a Ruby script, how can you capture
what gets written to `STDOUT`? How do you go about capturing both `STDOUT` and
`STDERR` streams?
The ruby standard libraru Open3 provides a simple way to access stdout and stderr without having to do any parsing of one's own.

**Q7:** How can you efficiently write the contents of an input file 
to `STDOUT` with empty lines omitted? Being efficient in this context
means avoiding storing the full contents of the input file in memory 
and processing the stream in a single pass.

File.open("samplefile.txt").readline do |line|
  puts line unless line.chomp.empty?
end

**Q8:** How would you go about parsing command line arguments that contain a mixture
of flags and file arguments? (i.e. something like `ls -a -l foo/*.txt`)
I would use a library like OptionParser to first extract the flags that I'm looking for. 

Ex.

params = {}
parser = OptionParser.new 

parser.on("-a") { params[:all_files] ||= true         }
parser.on("-l") { params[:show_permission]   = true }

files = parser.parse(ARGV)

parser.parse extracts the -a and -l from ARGV and sets the rest equal to files.

**Q9:** What features are provided by Ruby's `String` class to help with fixed width
text layouts? (i.e. right aligning a column of numbers, or left aligning a
column of text with some whitespace after it to keep the total 
column width uniform)
String provides methods such as rjust and ljust that take an integer in order to right or left justify the string.

**Q10:** Suppose your script encounters an error and has to terminate itself. What is
the idiomatic Unix-style way of reporting that the command did not run
successfully?

It would be to first have the application be aware of differing types of erros from incorrect input to failure during processing and then to show to the end user the command they called, an error message and when applicable a helpful tip. One immediate example that comes to mind is git where if I type a command like git commt it will be smart enough to suggest to me 'do you mean commit'.

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
$ ls foo
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

To complete this step, you will probably need to take a closer look at how `ls` behaves
when it is being used directly vs. how it behaves when it is run in a subshell
or as part of a command pipeline. The output format is actually simplified in
the latter case, with each entry being listed on its own line.

To see how this works, run each of commands listed in STEP 1, but pipe the output
to the cat utility, i.e. instead of typing `ls`, type `ls | cat`. It's
this behavior you will need to clone to get your `ruby-ls` program 
working correctly -- the screen output for human consumption is optional.

**STEP 4:** Work your way through implementing some or all of the other use cases
listed in step 1. Start by uncommenting an acceptance test in `ls_tests.rb`, then implement
the correct behavior in the `ruby-ls` script.

Remember that you'll want to emulate the machine readable output of `ls` rather
than just the console-based output. Also keep in mind that your exit codes
will need to match that of `ls` for successful and failed executions in
order to pass the tests.

*If you get stuck or have questions about this exercise, file a ticket in our
Github tracker. If you'd like a code review, please submit a pull request with
your solution. Feel free to submit stuff that is still a work-in-progress!*
