## Part 3: Parsing text-based file formats

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

Coming soon!

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
objects. You can use any syntax you like for this, i.e. something like 
`1\3 + 1\6`, but avoid overloading the `/` operator.

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
