**Q1: What steps are involved in making a Ruby scripts runnable as a command line utility? (i.e. directly runnable like `rake` or `gem` rather than having to type `ruby my_script.rb`)**

1. Add a shebang line to the top of your script, i.e. `#!/usr/bin/env ruby`
2. Make the script executable: `$ chmod +x my_script_name`
3. Add the script to your path: `$ export PATH=/path/to/project/folder:$PATH`

**Q2: What is `ARGF` stream used for in Ruby?**

The `ARGF` construct is a stream that processes input data either via files
passed in as command line arguments, or via `STDIN`. It will also combine 
multiple files into a single stream, which is useful for bulk file processing.

`ARGF` constructs its stream based on the arguments in `ARGV`, so manipulating
`ARGV` to add or remove files will affect what can be read from the `ARGF`
stream. You can see more details on this in the Ruby API documentation:

http://ruby-doc.org/core-2.1.1/ARGF.html

**Q3: What is `$?` used for in Bash/Ruby?**

In bash, `$?` holds the exit status of the last executed command as an
integer.

In ruby, `$?` has the same purpose, but it holds a `Process::Status` object that
provides some additional convenience methods and metadata in addition to the
status (i.e. things like whether the process was terminated by an exteral
signal, whether it resulted in success or failure, etc). 
Calling `$?.exitstatus` will return the same numeric value that you'd get
from `$?` in a Bash script.

For more details on what methods the `Process::Status` object provides, see the 
Ruby API documentation: 

http://www.ruby-doc.org/core-2.1.1/Process/Status.html

**What does an exit status of zero indicate when a command line script 
terminates? How about a non-zero exit status?**

A zero exit status indicates that the command executed successfully, a non-zero
status indicates that something went wrong.

Application programmers are able to use most of the values between 0-255 for
application-specific purposes, but some status codes are reserved for special
circumstances. See the following link for more details:

http://www.tldp.org/LDP/abs/html/exitcodes.html

Using `abort` in Ruby will automatically set the exit status to `1`, which is a
general catchall for errors. In most cases this is sufficient, but when finer
grained control is needed it is possible to call `exit` or `exit!` with a
specific exit status code.

**Q4: What is the difference between the `STDOUT` and `STDERR` output streams?**

The `STDOUT` stream is meant for the meaningful output from a script, i.e. the
thing you'd consider the end result of the program, or something that is meant
to be piped into another script for further processsing.

The `STDERR`  stream is for debugging and error output, which is useful for programmers and
error handling systems but is not meant to be processed as part of the normal
output of a script.

**When executing shell commands from within a Ruby script, how can you capture
what gets written to `STDOUT`? How do you go about capturing both `STDOUT` and
`STDERR` streams?**

To capture what gets written to `STDOUT`, you can use the backticks operator:

```ruby
output = `ls -l`
p output
```

To capture both `STDOUT` and `STDERR` (as well as the exit status), you can use 
the `Open3` standard library:

```ruby
require "open3"

ls_out, ls_err, ls_process = Open3.capture3("ls some_missing_dir")

p [ls_out, ls_err, ls_process.exitstatus]
#=> ["", "ls: some_missing_dir: No such file or directory\n", 1]
```

For more details on `Open3`, see the Ruby API documentation:
http://ruby-doc.org/stdlib-2.1.1/libdoc/open3/rdoc/Open3.html

**Q5: How can you efficiently write the contents of an input file 
to `STDOUT` with empty lines omitted? Being efficient in this context
means avoiding storing the full contents of the input file in memory 
and processing the stream in a single pass.**

The key thing to remember is to avoid calling methods like `File#read`, which will
read all of the content into a single Ruby string.

For simple use cases, using a block iterator will do, e.g. something like:

```ruby
File.foreach("foo.txt") { |f| puts f unless f.strip.empty? }
```

For more complex cases where you want to have processing happen in a helper
method or collaborating object, you can use an enumerator:

```ruby
enum = File.foreach("foo.txt")
some_processing_method(enum)
```

Elsewhere, you'd have code that looks like this:

```ruby
def some_processing_method(lines)
  # advance the pointer to the next non-blank line
  lines.next while lines.peek.strip.empty?

  # do something interesting here
end
```

Enumerators are lazily evaluated, so they do not need to load the entire
contents of the file into memory to perform this sort of operation, even though
it appears as if you are working with a collection of text lines.

Any solution involving enumerators could be rewritten to use the more familiar
block iterator style, but doing so makes it a little more difficult to pass data
downstream for further processing in a helper method. With an iterator-based
approach, all control flow has to be done in the top level block. 

Both techniques have their merits, so it usually depends on the problem at hand
which you should use. Iterators are more conceptually simple than enumerators,
so they may be a good default if you're unsure which approach to take.

**Q6: How would you go about parsing command line arguments that contain a mixture
of flags and file arguments? (i.e. something like `ls -a -l foo/*.txt`)**

Ruby provides several tools for options parsing. Except for trivial cases it
does not make sense to process the `ARGV` array directly, because processing
command line arguments can be a more challenging problem than it seems 
on the surface. 

The `OptionParser` standard library is probably the most versatile solution that
ships with Ruby, and it is well documented:

http://www.ruby-doc.org/stdlib-2.1.1/libdoc/optparse/rdoc/OptionParser.html

Two things to note about `OptionParser` though: 

1) It definitely feels like a "kitchen sink" library that does far more than
what you'll need from it.

2) The commonly documented way of using `OptionParser` involves manipulating
`ARGV` indirectly via side effect, which seems like a messy solution.

Despite these caveats, it is possible to use `OptionParser` in a fairly clean
and lightweight fashion, as shown in the "Building Unix-style command line
applications" article:

```ruby
module RCat
  class Application
    # other code omitted

    def parse_options(argv)
      params = {}
      parser = OptionParser.new 

      parser.on("-n") { params[:line_numbering_style] ||= :all_lines         }
      parser.on("-b") { params[:line_numbering_style]   = :significant_lines }
      parser.on("-s") { params[:squeeze_extra_newlines] = true               }

      files = parser.parse(argv)

      [params, files]
    end
  end
end
```

This approach does not directly operate on `ARGV`, and it uses only a minimal
subset of `OptionParser` features. In many cases, this is all you will need.

For the true minimalist that does not mind living dangerously, you can use the
`ruby -s` command line option to convert provided flags into global variables.
See the solution Benoit Daloze sent in for the ls clone exercise for an example
of this technique being used: 

https://github.com/elm-city-craftworks/course-001/pull/1

Ruby also provides a library called `getoptlong` but it has an awkward interface
and isn't commonly used anymore.

If all of this isn't enough, there are lots of third party libraries and frameworks that
handle command line options parsing their own way. Use them if you see a clear
benefit specific to your project, but if you don't already have a strong opinion
on this topic, it's better to just stick with `OptionParser` so that you don't
spend too much time thinking about what color to paint the bikeshed.

**Q7: What features are provided by Ruby's `String` class to help with fixed width
text layouts? (i.e. right aligning a column of numbers, or left aligning a
column of text with some whitespace after it to keep the total 
column width uniform)**

The following `String` methods are useful when formatting plain text reports 
in Ruby:

* `ljust`, `rjust`, and `center` for aligning text within columns and/or 
adding padding to strings.

* `strip`, `lstrip`, `rstrip`, `chomp` for dealing with whitespace.

* The `%` operator for using `sprintf` style patterns to format data, particularly
when deciding how to format numbers.

See the Ruby API documentation for more details on how these methods are used:
http://www.ruby-doc.org/core-2.1.0/String.html

> Q5: Suppose your script encounters an error and has to terminate itself. What is
the idiomatic Unix-style way of reporting that the command did not run
successfully?

Gracefully failing involves two steps:

1. Exit with a non-zero status
2. Print any useful debugging / error output to STDERR

To handle both of these requirements at once, you can either use 
Ruby's `abort()` method to exit without raising an exception, or 
use `raise()` which will output the stack trace to STDERR and 
set the exit status appropriately.  

If you need finer-grained control, you can also do both steps
manually:

```ruby
STDERR.puts "I didn't succeed!"
exit 1
```

For non-fatal errors and debugging output, you can still write to 
`STDERR` as shown above, just omit the exit call. 

If the messages you are printing are warnings, you can use 
the `warn` method to allow the messages to be optionally disabled.

```ruby
warn "Something went wrong!
```

Under the hood, `warn` writes to STDERR, so it works in an idiomatic way
as far as Unix commands are concerned. Most logging tools will also
use STDERR rather than STDOUT by default.

---

For more details on all of the above answers, see the "Building Unix-style
command line applications" article in Practicing Ruby:

https://practicingruby.com/articles/building-unix-style-command-line-applications
