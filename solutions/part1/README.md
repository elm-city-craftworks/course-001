### TODO: Fill this in with an overview of the solution

**ls_tests.rb**: Contains acceptance tests to match `ruby-ls` output to the `ls`
system utility for the use cases covered by this exercise. Uses a test runner
inspired by Jacob Tjoernholm's solution, which gives very detailed output 
on failures.

**test/units/file_details.rb**: Some very basic and somewhat brittle tests for
the `RubyLS::FileDetails` object. Mostly useful as a smoke test, and would need
to be modified to be more robust.
