## Reading Materials

(summary here)

## Questions

(fill me in)

## Exercises

> NOTE: The supporting materials for these exercises are in `samples/part1`.

In the "Building Unix-style command-line applications" article, we walked
through implementing a Ruby clone of the Unix `cat` utility. In this set of
exercises, you'll repeat a similar process to build a minimal clone of
the `ls` command. By doing so, you'll explore many of Ruby's capabilities
for working with files.

1) Run the following bash commands in the `data` folder and copy the 
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

2) Get the test harness in `ls_tests.rb` to pass its first test.
The script in `bin/ruby-ls` is a wrapper around the system `ls`
utility, so you should only need to add it to your shell's path in order
to get your first test passing. On a successful run, you should expect to
see the following output:

```
Test 1: OK
Next step: add a test for ruby-ls foo/*.txt
```

3) Now replace the `ruby-ls` script with a Ruby-based implementation 
that passes the first test.

4) Work your way through implementing some or all of the other use cases
listed in step 1. Start by adding an acceptance test, then implement
the correct behavior in the `ruby-ls` script.

5) If you didn't already check for exit codes for successful and unsuccessful
uses of the `ruby-ls` command, add a test for them now and then implement
command termination behavior that matches how `ls` works on your system.
