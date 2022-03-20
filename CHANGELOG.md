### 2014.07.16

* Solutions for Part 4 are now available on the `solutions` branch.

### 2014.06.10

* Course materials for Part 4 released!

### 2014.06.07

* Solutions for Part 3 are now available on the `solutions` branch. 

### 2014.05.16

* Course materials for Part 3 released!

### 2014.05.07

* Solutions for Part 2 are now available on the `solutions` branch.

### 2014.05.01

* Added a test case for Part 2 that covers multibyte Unicode characters
in MessagePack data. Run the `unicode_messages.rb` file to test your
implementation.

### 2014.04.29

* Add Jacob's test runner and all necessary acceptance tests to `ls_tests.rb`,
so that people do not need to write their own tests from scratch. This should
simplify the exercise a little bit. 

### 2014.04.20

* Reorganize `solutions` branch, clean up README.md a little bit 
in `master` branch.

### 2014.04.19

* Course materials for Part 2 released!

### 2014.04.08

* Added an extra `ls` use case in PART_1.md, covering basic `ls somedir` usage.
This complicates implementation somewhat, but is an important feature even
for a minimal clone.

### 2014.04.07

* Added a clarification in PART_1.md about how `ls` works differently depending on whether it
is outputting directly to the console or being run in a 
subshell / command pipeline. For the purpose of the exercise, we'll focus on the
latter because our acceptance tests run `ls` in a subshell, and because the
machine readable output is easier to implement.

* Added CHANGELOG.md

### 2014.04.03

* Course materials for Part 1 released!
* Fix minor issue with mislabeled commands in Part 1 tests
