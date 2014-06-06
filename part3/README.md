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

Either returning `nil` or the token array `[false, "$end"]` will terminate
parsing. Returning `nil` is an undocumented feature, but results in
cleaner looking code, as shown below:

```ruby
# using explicit token array
def next_token
  return [false, "$end"] if some_condition

  # ...
end

# using implicit nil return value
def next_token
  return if some_condition

  # ... 
end
```

**Q4: The RJSON parser shown in the article would fail to parse 
the following JSON strings:**

* `{"a" : 1, "b" : 2, "c" : 3}`
* `[1, 2, 3]`

**Find out why, and suggest a fix for the problem.**

Neither the parser nor the tokenizer shown in the "Parsing JSON the Hard Way"
article were written to handle whitespace. Because whitespace does not have
any special meaning in JSON, an easy fix to this problem is to silently
discard any whitespace the tokenizer encounters between significant tokens:

```ruby
def next_token
  @ss.skip(/\s+/)

  # ...
end
```

This approach can be used in any StringScanner-based tokenizer, as long as
the input text format is not whitespace sensitive.

Skipping over whitespace can also be done at the Racc grammar level, but it
would complicate the parsing rules without much of a benefit. If we were
attempting to parse an input format with significant whitespace (e.g.
HAML markup or Python code), doing whitespace processing at the Racc
grammar level would make a lot more sense.

**Q5: The RJSON parser can be customized by providing it an alternative
document handler that implements a few methods -- `start_object`,
`end_object`, `start_array`, `end_array`, and `scalar`. Give an example of a
realistic use case that illustrates why this feature can be useful.**

One possible application would be to build a converter from JSON to
some other serialization format without first creating a full Ruby
representation of the JSON data.

So for example, the following handler is capable of converting JSON data 
to MessagePack format without the need for an intermediate representation 
of the data structure:

```ruby
class MessagePackHandler
  def initialize
    @buffer        = [""]
    @packer        = MessagePack::Packer.new
    @counter_stack = [0]
  end

  def scalar(s)
    @counter_stack[-1] += 1
    @buffer[-1] << s.to_msgpack
  end

  def start_collection
    @counter_stack[-1] += 1
    @counter_stack.push(0)

    @buffer.push("")
  end

  alias_method :start_array, :start_collection
  alias_method :start_object, :start_collection

  def end_collection(name, size)
    raise ArgumentError unless [:map, :array].include?(name)

    object_body = @buffer.pop

    @buffer[-1] << @packer.send("write_#{name}_header", size).to_str <<
                   object_body

     @packer.clear
  end

  def end_array
    end_collection(:array, @counter_stack.pop)
  end

  def end_object
    end_collection(:map, @counter_stack.pop / 2)
  end

  def result
    @buffer.first
  end
end
```

The following code could be used to tell `RJSON` to use this 
alternative handler:

```ruby
input = StringIO.new('{"a" : 1, "b" : [2,3,[4,5],6], "c" : "kittens"}')
tok = RJSON::Tokenizer.new(input)
parser = RJSON::Parser.new(tok, MessagePackHandler.new)

p MessagePack.unpack(parser.parse.result)
```

**Q6: What benefits are there in creating an intermediate representation
of parsed data rather than directly converting to a desired format/structure?**

(Show how the messagepack converter could have been done via the intermediate
representation, too)

http://cs.lmu.edu/~ray/notes/ir/

**Q7: What is an important difference between wrapping text in a `StringIO` object 
vs. using an `IO` object directly when performing I/O operations?**

StringIO necessitates putting all the data in a string before processing it. I/O
can read from an external source.

**Q8: RJSON provides both a [StringScanner-based
tokenizer](https://github.com/tenderlove/rjson/blob/master/lib/rjson/tokenizer.rb)
and a [streaming
tokenizer](https://github.com/tenderlove/rjson/blob/master/lib/rjson/stream_tokenizer.rb).
What are the tradeoffs involved in each of these approaches?**

Basically same as Q7, but tradeoff is complexity.
