## Questions

> NOTE: Most of these questions can directly be answered by reading 
> the article, but a few might require you to search the web for
> answers. External research is not only OK, it's encouraged!x<

* What steps are involved in making a Ruby scripts runnable as a 
command line utility? (i.e. directly runnable like `rake` or `gem`
rather than having to type `ruby my_script.rb`)

1. Make sure the file has the executable in it's permission list. If it
does not, add it by using `chmod +x <filename>`
2. Add the #! to indicate the path to tell the shell what interpreter
to use 
3. Add the file to the $PATH variable

* What is `ARGF` stream used for in Ruby?

A: ARGF is used to combine multiple file streams into one input

* What is `$?` used for in Bash/Ruby?

A: When using the backtick(`) character to run shell commands from
withing a ruby script, ruby will assing the process object to this
variable. You can then interact with this object to obtain information
such as exit code.

* What does an exit status of zero indicate when a command line script 
terminates? How about a non-zero exit status?

A: An exit status of 0 indicates successful operation. Non zero exit code means
that the script failed

* What is the difference between the `STDOUT` and `STDERR` output streams?

A: STDOUT should be used to indicate process status or other output for the user,
and STDERR is used to log debugging output

* When executing shell commands from within a Ruby script, how can you capture
what gets written to `STDOUT`? How do you go about capturing both `STDOUT` and
`STDERR` streams?

A: Using the Open3.capture3 method you can capture what is written to STDOUT
and STDERR

* How can you efficiently write the contents of an input file 
to `STDOUT` with empty lines omitted? Being efficient in this context
means avoiding storing the full contents of the input file in memory 
and processing the stream in a single pass.

A: By using an Enumerator object you can can loop over the lines, looking ahead
for empty lines or the EOF. 

* How would you go about parsing command line arguments that contain a mixture
of flags and file arguments? (i.e. something like `ls -a -l foo/*.txt`)

A: Ruby has a built in OptionsParser allowing you to pull in the flags in a much
cleaner fashion than inspecting the ARGV elements.

* What features are provided by Ruby's `String` class to help with fixed width
text layouts? (i.e. right aligning a column of numbers, or left aligning a
column of text with some whitespace after it to keep the total 
column width uniform)

A: The String class has ljust, rjust, and center methods to help with text
alignment

* Suppose your script encounters an error and has to terminate itself. What is
the idiomatic Unix-style way of reporting that the command did not run
successfully?

The script should exit with a exit code of 1 and write to the STDERR a reason
for the failure. Make sure not to write to STDOUT to keep the process output
separate from the debugging output.

ps. I really like the self guided course. Thank you for doing this.