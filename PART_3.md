## Part 3: Parsing text-based formats

The article we'll work through in this part of the 
course is [Parsing JSON the hard way](https://practicingruby.com/articles/parsing-json-the-hard-way).
Reading it carefully should prepare you to work through the questions
and exercises for this topic.

We still have not released the practice materials for this part of the course
yet, but you are welcome to get a head start on the reading, or work on
the parts of the course that have already been released (see the README
in the project root for details)

## Questions

> NOTE: Several of these questions can directly be answered by reading 
> the article, but some might require you to search the web for
> answers. External research is not only OK, it's encouraged!

**Q1:** Racc is a LALR parser generator. Briefly summarize what a LALR
parser is, using as little jargon as possible.

**Q2:** Briefly describe what gets generated when Racc converts a grammar
file into a Ruby file.

**Q3:** To let a Racc parser know that there are no tokens left to 
be processed, what should the `next_token` method return?

**Q4:** The RJSON parser shown in the article would fail to parse 
the following JSON strings: 

* `{"a" : 1, "b" : 2, "c" : 3}`
* `[1, 2, 3]`

Find out why, and suggest a fix for the problem.

**Q5:** The RJSON parser can be customized by providing it an alternative
document handler that implements a few methods -- `start_object`,
`end_object`, `start_array`, `end_array`, and `scalar`. Give an example of a
realistic use case that illustrates why this feature can be useful.

**Q6:** What benefits are there in creating an intermediate representation
of parsed data rather than directly converting to a desired format/structure?**

**Q7:** What is the main difference between wrapping text in a `StringIO` object 
vs. using an `IO` object directly when performing I/O operations?

**Q8:** RJSON provides both a [StringScanner-based
tokenizer](https://github.com/tenderlove/rjson/blob/master/lib/rjson/tokenizer.rb)
and a [streaming
tokenizer](https://github.com/tenderlove/rjson/blob/master/lib/rjson/stream_tokenizer.rb).
What are the tradeoffs involved in each of these approaches?

## Exercises

> NOTE: The supporting materials for these exercises are in
> [samples/part3][part3-samples]

In this set of exercises, you will add functionality to the canonical basic
calculator example that ships with Racc. By doing so, you'll exercise
many of the same tools and techniques covered in the "Parsing JSON the
hard way" article while also learning a few new Racc features 
along the way.

**STEP 1:** Compile and run the calculator example. 
At the command prompt, type the following statements and
verify that they work as expected:

* `1 + 1`
* `(2 + 3) * 5`
* `-5 * 3`
* `(9 - 3) / 2`

**STEP 2:** Replace the low-level code in the `parse()` method in `calc.y` 
with an equivalent solution that uses `StringScanner`. If you need help
getting started, see the [RJSON::Tokenizer source code][tokenizer] for ideas.

**STEP 3:** Modify the parser to support both integers and floating point
numbers in equations, i.e. `1 + 3.14159`.

**STEP 4:** Modify the parser to convert fractional numbers into `Rational`
objects. To avoid overloading the `/` operator, consider using backslashes
instead of forward slashes, i.e. `1\3 + 1\6`. You could also choose a different
syntax entirely, as long as you provide an easy way to write fractions.

**STEP 5:** Modify the parser to support bound variables. This should work by
passing parameters to the `Calcp` constructor, which would then be 
accessible in equations.

For example, if you modify the `Calcp` instantiation line in the footer of `calc.y`
to look like this:

```ruby
parser = Calcp.new(:x => 10, :y => 15, :z => 3)
```

Then the following equations should be made to work:

* `x + 5`
* `x * y * z`
* `(x + y) * 2`

**EXTRA CREDIT:** Add additional extensions to the calcuator, like assignment
(e.g `x = 42`, `y = 3*x`), bound function calls (i.e. `f(x)`, `f(3 + y)`),
an irb-style magic variable that refers to the last computed result (e.g. `_ *
2`), or any other interesting extension that you might expect to find in a
text-based calculator.

[tokenizer]: https://github.com/tenderlove/rjson/blob/master/lib/rjson/tokenizer.rb
[part3-samples]: https://github.com/elm-city-craftworks/course-001/tree/master/samples/part3
