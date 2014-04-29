## Questions

* What steps are involved in making a Ruby scripts runnable as a 
command line utility? (i.e. directly runnable like `rake` or `gem`
rather than having to type `ruby my_script.rb`)

1. Adding a shebang line at the top: `#!/usr/bin/env ruby`
1. Setting execute permission on the file: `chmod +x bin/myrake`
1. Adding the bin directory to your PATH: `export PATH=/Users/jtj/projects/myrake/bin:$PATH`

* What is `ARGF` stream used for in Ruby?

It combines multiple input files into a stream or uses standard input if no
files are provided.

* What is `$?` used for in Bash/Ruby?

When executing a shell command with backticks, it is assigned a
Process::Status instance for the executed process. 

* What does an exit status of zero indicate when a command line script 
terminates? How about a non-zero exit status?

Zero means successful execution. Non-zero indicates some kind of error,
specific to the utility (I think?).

* What is the difference between the `STDOUT` and `STDERR` output streams?

`STDOUT` is used for the actual output of the utility, `STDERR` is used for
debugging and error messages. 

* When executing shell commands from within a Ruby script, how can you capture
what gets written to `STDOUT`? How do you go about capturing both `STDOUT` and
`STDERR` streams?

This can be done using the `Open3` module in the Ruby standard library.

* How can you efficiently write the contents of an input file 
to `STDOUT` with empty lines omitted? Being efficient in this context
means avoiding storing the full contents of the input file in memory 
and processing the stream in a single pass.

Using an enumerator obtained from `IO#each_line`, looking ahead and ignoring
empty lines in a `loop`. 


* How would you go about parsing command line arguments that contain a mixture
of flags and file arguments? (i.e. something like `ls -a -l foo/*.txt`)

Using `optparse` from the standard library.


* What features are provided by Ruby's `String` class to help with fixed width
text layouts? (i.e. right aligning a column of numbers, or left aligning a
column of text with some whitespace after it to keep the total 
column width uniform)

`#rjust`, `#ljust` and `#center`.


* Suppose your script encounters an error and has to terminate itself. What is
the idiomatic Unix-style way of reporting that the command did not run
successfully?

By returning a non-zero exit code. This can be done directly with `exit(1)` or
through the convenient `abort` wrapper which also writes to STDERR: `abort
"File not found"`.

