### TODO: Fill this in with an overview of the solution

**bin/ruby_ls** [source][ruby-ls] 

Command line script that handles the basic I/O chores for the
`RubyLS` application, including argument parsing and formatted output. No logic
is done at this level, it's just UI code and related underplumbing.

**lib/ruby_ls.rb**:

Defines `RubyLS.match_files` which determines which files to include in the
`Listing` object. Runs a success callback when all files are matched, 
otherwise runs a failure callback when a file cannot be found.

**lib/ruby_ls/listing.rb**:

Defines the `Listing` object, which wraps a collection of `FileDetails` objects
with some basic aggregations (i.e. length of each cell in a column, 
sum of the total number of blocks in the listed files, etc.)

**lib/ruby_ls/file_details.rb**:

Defines the `FileDetails` object which pulls all necessary metadata about a
single file. Most of the functionality in this object directly wrap features
provided by Ruby's `Etc` and `File::Stat` objects, but the conversion of 
file permission to a human readable form is done from scratch.

**ls_tests.rb**: 

Contains acceptance tests to match `ruby-ls` output to the `ls`
system utility for the use cases covered by this exercise. Uses a test runner
inspired by Jacob Tjoernholm's solution, which gives very detailed output 
on failures.

**test/units/file_details.rb**: 

Some very basic and somewhat brittle tests for
the `RubyLS::FileDetails` object. Mostly useful as a smoke test, and would need
to be modified to be more robust.

[ruby-ls]: https://github.com/elm-city-craftworks/course-001/blob/solutions/solutions/part1/bin/ruby-ls
