-----

**TODO:** Add calculator solution

----

## Answers to reading questions from Part 3

**Q1: Racc is a LALR parser generator. Briefly summarize what a LALR
parser is, using as little jargon as possible.**

A LALR parser is a parser that:

* Parses text in a single direction. Backtracking is avoided by
looking ahead in the input stream before deciding how to 
parse a single token. (*LA = Look-ahead*)

* Parses text starting from the left-most side of the input stream.
 (*L=Left-to-right input processing*)

* Builds a parse-tree from the bottom up by repeatedly attempting to match 
the right side of grammar rules, until the full input stream is used up.
For example, parsing the string `X + Y * Z` would match
the variable names first, then the multiplication expression, then
finally the addition expression. (*R=Right-most derivation*)

To implement a LALR parser, it is necessary to build a very low-level
finite state machine, which is quite difficult to do by hand. Parser
generators like Yacc/Racc allow you to specify the grammar you need
to parse at a very high level and then generate the state transition
tables for you.

LALR parsers are powerful enough to parse the grammars for 
many programming languages, but because of an optimization
they use to condense their lookup tables, can generate
conflicts in certain edge cases that arise in complex grammars.

Because of their complexity, LALR parsers can be hard to understand
and hard to debug. The use of parser generators like Yacc/Racc
mitigate this somewhat, but not entirely.

Further reading:

* [LR Parser Wikipedia page](http://en.wikipedia.org/wiki/LR_parser)
* [LALR Parser Wikipedia page](http://en.wikipedia.org/wiki/LALR_parser)
* [Derivations, Parse Trees, and Ambiguity](http://www.cs.utsa.edu/~wagner/CS3723/grammar/grammars2.html)
* [A Tutorial Explaining LALR(1) Parsing](http://web.cs.dal.ca/~sjackson/lalr1.html)
* [What are the main advantages and disadvantages of LL and LR parsing?](http://programmers.stackexchange.com/a/19637)

**Q2: Briefly describe what gets generated when Racc converts a grammar
file into a Ruby file.**

Ruby code generated from a Racc grammar will have different contents
depending on what features it uses, but you can generally expect
a generated parser to do the following things:

* Require `racc/parser` stdlib, in order to load the `Racc::Parser` class.

* Generate a subclass of `Racc::Parser` based on the class name you specify in
your grammar file.

* Generate several arrays of data which represent the state transition 
tables to be used by the parser. These tables tell the parser when to shift 
new state onto the parse stack, when to perform a reduction (triggering the 
Ruby code attached to a given rule), what state to transition to after 
each reduction, and when to stop parsing the input stream.

* Generate methods for all Ruby code that will be run whenever a rule 
is matched, typically named something like `_reduce_1`, `_reduce_2`, etc.

* Add all code specified in the `---- inner` section of the grammer file to the
generated subclass.

* Add all code specified in the `---- footer` section to the bottom of the file.

Many of these code-generation behaviors are self-explanatory, but the 
construction of the state transition tables is non-obvious unless you are 
very familiar with LR parser implementation details. For a good overview of 
the topic, see this 
[Introduction to Shift-Reduce parsing](http://www.cs.binghamton.edu/~zdu/parsdemo/srintro.html).

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

