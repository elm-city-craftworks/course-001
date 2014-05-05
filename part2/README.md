-----------------------------------------------------------------

**NOTE:** For the reference implementation of the MessagePack exercise,
see the `message_pack` folder and its `README.md` file.

-----------------------------------------------------------------

## Answers to reading questions from Part 2

**Q1:** Why is it necessary to open files in binary mode when processing binary data
rather than using the default text-based mode for stream processing?

FIXME

**Q2:** What does it mean for binary data to be stored in big-endian byte order? How
about little-endian byte order? 

FIXME

**Q3:** List one reason for storing data in big-endian order, and one reason for storing
data in little-endian order.

FIXME

**Q4:** Describe in English what is happening in the following code snippet: 
`["BM", 300, 0, 0, 54].pack("A2Vv2V")`.  In particular, list out the
type that each value is being encoded as, as well as its size in bytes.

FIXME

**Q5:** How do you construct a `pack/unpack` pattern for a 32bit signed integer
in little endian order?

FIXME

**Q6:** What can go wrong if you rely on encoding/decoding binary data in "native order"
rather than explicitly specifying endianness?

FIXME

**Q7:** Suppose you want to know the RGB values for the third pixel
in a bitmap image. If you know that the pixel array begins 54 bytes
into the file, and each pixel consists of 3 bytes of data, what
is the minimum amount of data you would need to read from the
file to get this information (in bytes)? Briefly explain the 
reason behind your answer.

FIXME

**Q8:** Why do some binary file formats (including BMP images) pad binary data to
align with word boundaries (i.e. 4 byte chunks)? What is the cost of
organizing things this way?

FIXME

**Q9:** Why are basic validations so important when processing binary 
file formats? What are some examples of simple validations that can help you
ensure the consistency of a binary file?

FIXME

**Q10:** Name three advantages and three disadvantages of using binary file
formats vs. using text-based file formats. Try to give specific examples
where possible.

FIXME

