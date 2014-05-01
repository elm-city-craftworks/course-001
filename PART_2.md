## Part 2: Encoding and decoding binary files

The article we'll work through in this part of the 
course is [Working with binary file formats](https://practicingruby.com/articles/binary-file-formats).
Reading it carefully should prepare you to work through the questions
and exercises for this topic.

## Questions

> NOTE: Several of these questions can directly be answered by reading 
> the article, but some might require you to search the web for
> answers. External research is not only OK, it's encouraged!

**Q1:** Why is it necessary to open files in binary mode when processing binary data
rather than using the default text-based mode for stream processing?

**Q2:** What does it mean for binary data to be stored in big-endian byte order? How
about little-endian byte order? 

**Q3:** List one reason for storing data in big-endian order, and one reason for storing
data in little-endian order.

**Q4:** Describe in English what is happening in the following code snippet: 
`["BM", 300, 0, 0, 54].pack("A2Vv2V")`.  In particular, list out the
type that each value is being encoded as, as well as its size in bytes.

**Q5:** How do you construct a `pack/unpack` pattern for a 32bit signed integer
in little endian order?

**Q6:** What can go wrong if you rely on encoding/decoding binary data in "native order"
rather than explicitly specifying endianness?

**Q7:** Suppose you want to know the RGB values for the third pixel
in a bitmap image. If you know that the pixel array begins 54 bytes
into the file, and each pixel consists of 3 bytes of data, what
is the minimum amount of data you would need to read from the
file to get this information (in bytes)? Briefly explain the 
reason behind your answer.

**Q8:** Why do some binary file formats (including BMP images) pad binary data to
align with word boundaries (i.e. 4 byte chunks)? What is the cost of
organizing things this way?

**Q9:** Why are basic validations so important when processing binary 
file formats? What are some examples of simple validations that can help you
ensure the consistency of a binary file?

**Q10:** Name three advantages and three disadvantages of using binary file
formats vs. using text-based file formats. Try to give specific examples
where possible.


## Exercises

> NOTE: The supporting materials for these exercises are in `samples/part2`

In this set of exercises, you will explore and implement a minimal subset
of the [MessagePack][] binary serialization format. By doing so, you'll exercise
many of the same tools and techniques covered in the "Working with binary file
formats" article while also familiarizing yourself with a fast and efficient
alternative to JSON for data serialization.

**STEP 1:** The `example.msg` file contains a collection of key-value pairs 
encoded as a MessagePack `fixmap`. Using the [MessagePack spec][spec] and a hex dump
utility (i.e. `xxd` or something similar), examine the contents 
of the file and see if you can discover the following details
about the stored data:

* The size of the map (i.e. the number of key-value pairs)
* The human readable ASCII representation for each of the keys (all of which are encoded with the `fixstr` type)
* The type of each value in the map (i.e. `"foo" => fixint, "bar" => float 64` )

The very first byte in the file will tell you how many elements the 
encoded `fixmap` has, and then you'll repeat a similar process to 
uncover the details about its keys and values.

**STEP 2:** Implement the `Unpacker.unpack` method, which takes an array of bytes
encoded in MessagePack format and converts it to an equivalent primitive 
Ruby object. The `unpacker.rb` file contains a stubbed out method for you to
implement, as well as a simple test. You are only expected to implement enough
of MessagePack's functionality to process the `example.msg`, 
small subset of the types available in MessagePack.

**STEP 3:** Implement the `Packer.pack` method, which takes a primitive Ruby
object and converts it into a byte array in MessagePack format. You'll find
a stub method and test for this in `packer.rb`. As in STEP 2, you're only
expected to convert the limited set of types used in the `example.msg` file, you
do not need to write a converter for all Ruby formats.

**STEP 4:** Using the extension type interface provided by MessagePack, revise
`Packer.pack` and `Unpacker.unpack` to support encoding and decoding of Ruby
symbols as an application-specific type. See `extended_messages.rb`
for a test case that covers this scenario.

**STEP 5:** MessagePack specifies that its string type is meant to be encoded
in UTF-8. See `unicode_messages.rb` for a test that verifies that multibyte
characters can be packed and unpacked. If your implementation fails the
test, fix it so that it passes.

[MessagePack]: http://msgpack.org/
[spec]: https://github.com/msgpack/msgpack/blob/master/spec.md
