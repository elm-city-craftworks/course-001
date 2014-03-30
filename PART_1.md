## Reading Materials

(summary here)

## Questions

(fill me in)

## Exercises

1. Run the following bash commands in the samples/ls_reference_dir folder
and copy what appears in your console into a text file for future reference.

```bash
$ ls
$ ls -l
$ ls -a
$ ls -a -l
$ ls foo/*.txt
$ ls -l foo/*.txt
$ ls missingdir
```

2. Create a set of acceptance tests that cover how ls behaves on your system, 
based on your observations from the previous example.

3. Implement a clone of ls that passes as many of your acceptance tests as you can, 
starting with the easiest cases and moving on top the more complicated ones.

4. Add an acceptance test that checks the exit codes for a successful command 
and an unsuccessful command.

5. Update your ls clone to terminate with matching exit codes to the 
real ls command.
