-----

**TODO:** Add calculator solution

----

## Answers to reading questions from Part 3

**Q1: Racc is a LALR parser generator. Briefly summarize what a LALR
parser is, using as little jargon as possible.**

**Q2: Briefly describe what gets generated when Racc converts a grammar
file into a Ruby file.**

**Q3: To let a Racc parser know that there are no tokens left to 
be processed, what should the `next_token` method return?**

**Q4: The RJSON parser shown in the article would fail to parse 
the following JSON strings:**

* `{"a" : 1, "b" : 2, "c" : 3}`
* `[1, 2, 3]`

**Find out why, and suggest a fix for the problem.**

**Q5: The RJSON parser can be customized by providing it an alternative
document handler that implements a few methods -- `start_object`,
`end_object`, `start_array`, `end_array`, and `scalar`. Give an example of a
realistic use case that illustrates why this feature can be useful.**

**Q6: What benefits are there in creating an intermediate representation
of parsed data rather than directly converting to a desired format/structure?**

**Q7: What is an important difference between wrapping text in a `StringIO` object 
vs. using an `IO` object directly when performing I/O operations?**

**Q8: RJSON provides both a [StringScanner-based
tokenizer](https://github.com/tenderlove/rjson/blob/master/lib/rjson/tokenizer.rb)
and a [streaming
tokenizer](https://github.com/tenderlove/rjson/blob/master/lib/rjson/stream_tokenizer.rb).
What are the tradeoffs involved in each of these approaches?**

