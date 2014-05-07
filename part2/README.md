-----------------------------------------------------------------

**NOTE:** For an implementation of the MessagePack exercise,
see the `message_pack` folder and its `README.md` file.

-----------------------------------------------------------------

## Answers to reading questions from Part 2

**Q1: Why is it necessary to open files in binary mode when processing binary data
rather than using the default text-based mode for stream processing?**

When you open a file in binary mode, two important things happen:

* The encoding of the stream is set to be `ASCII-8BIT`, which means
that the data is treated as unencoded bytes and no attempt is made
to map the data to a particular character encoding.

* No attempt is made to convert between Windows-style newline characters
and Unix-style newline characters. On UNIX systems this does not matter,
but on Windows, opening a stream in the wrong mode can lead to 
data corruption.

Taken together, these two effects guarantee that streams can be processed
for their raw data, skipping the additional processing that Ruby does
to make text files easier to work with.

**Q2: What does it mean for binary data to be stored in big-endian byte order? How
about little-endian byte order?**

When storing multi-byte values, we are free to choose which order to process
the bytes in. Take for example the 32bit (4 byte) integer shown below:


```ruby
>> num = 0x0a_0b_0c_0d
=> 168496141
```

Broken up into individual bytes, we could store the numbers in the same order
we'd typically write them, which happens to be big-endian format:

```ruby
>> [num].pack("N").unpack("C*").map { |e| "%.2x" % e }
=> ["0a", "0b", "0c", "0d"]
```

We could also store the bytes in little-endian format, which represents
the same data packed in the opposite order:

```ruby
>> [num].pack("V").unpack("C*").map { |e| "%.2x" % e }
=> ["0d", "0c", "0b", "0a"]
```

As long as you know what format the data is stored in, it's just as easy to
work with the little-endian format as it is to work with big-endian format.
The decision to use one or the other is usually a matter of a semi-arbitrary
design decision at the very low system level, although there are some
minor differences that might cause a system designer to choose one over
the other.

**Q3: List one reason for storing data in big-endian order, and one reason for storing
data in little-endian order.**

According to the [Wikipedia article on Endianness][endianness], the primary
reason a system designer might favor the little-endian format is that it allows
for certain kinds of low level optimizations. For example, a memory location
with the value `4A 00 00 00` in little-endian format, which only contains
one byte of meaningful information, will retain the same value if it is read as
an 8-bit number (`4A`), 16-bit number (`4A 00`), 24-bit number (`4A 00 00`),
or 32-bit number (`4A 00 00 00`). This is not an optimization that would
typically be done by a high level programmer, but could be utilized
via a compiler or in assembly language programming.

The big-endian format facilitates a different kind of optimization, in that it
facilitates looking at the beginning of a message and making a useful
approximation based on that information alone. The example Wikipedia gives for
this is that of a phone number, in which area code gets transmitted to
the phone company first so that it can begin the routing process before
the user is even finished dialing. Because of use cases like this,
the big-endian format is sometimes referred to as "network order".

**Q4: Describe in English what is happening in the following code snippet: 
`["BM", 300, 0, 0, 54].pack("A2Vv2V")`.  In particular, list out the
type that each value is being encoded as, as well as its size in bytes.**

* `"BM"` is matched by `A2`, and produces a raw string in binary format. If
the source encoding is already `ASCII-8BIT` this is essentially a no-op.

* `300` is matched by `V`, and produces a 4-byte binary string with the 
32-bit unsigned integer packed in little-endian order.

* The two `0` values are matched by `v2`, and produce a pair of 2-byte
binary strings with 16-bit unsigned integers packed in little-endian order.

* `54` is matched by `V`, and produces a 4-byte binary string with the 
32-bit unsigned integer packed in little-endian order.

* All of these substrings are then joined together into one raw binary
string, which is returned by `pack`.

The output of this Ruby statement will look confusing if you try to directly
inspect the string in the console:

```ruby
>> ["BM", 300, 0, 0, 54].pack("A2Vv2V")
=> "BM,\x01\x00\x00\x00\x00\x00\x006\x00\x00\x00"
```

With a little bit of processing, you can get a better picture of what is
actually represented by this data:

```ruby
>> ["BM", 300, 0, 0, 54].pack("A2Vv2V").bytes.map { |e| "%.2x" % e }.join(" ")
=> "42 4d 2c 01 00 00 00 00 00 00 36 00 00 00"
```

From there, some casual experimentation can help you manually decode the data
back into its original form. When first working with binary file formats,
I found this to be an extremely useful way of familiarizing myself with
what was going on under the hood with `pack` and `unpack`. For example,
consider how the output below relates to what's shown above:

```ruby
>> 0x42.chr
=> "B"
>> 0x4d.chr
=> "M"
>> 0x00_00_01_2c
=> 300
>> 0x00_00
=> 0
>> 0x00_00
=> 0
>> 0x00_00_00_36
=> 54
```

Another alternative would have been to first dump the binary string to a file
and then use a hex editing tool to experiment with it. But even if you do
use a hex editor, it's helpful to have a Ruby console open for casual
calculations and experimentation.

**Q5: How do you construct a `pack/unpack` pattern for a 32bit signed integer
in little endian order?**

There is no single character pattern for matching this data type, so
it is necessary to use a compound pattern.

The directive that matches a 32 bit signed integer is `l`, but by default it
will use "native" endianness, which will depend on your operating system. To
ensure that the integer is read in little endian order, you need to add the
`<` modifier, resulting in the two character pattern `l<`.


```ruby
>> [0x0A0B0C0D].pack("l<").bytes.map { |e| "%.2x" % e }
=> ["0d", "0c", "0b", "0a"]
```

The `<` can be used to specify little endian order for any native directive.
To specify big endian order, use `>` instead.

**Q6: What can go wrong if you rely on encoding/decoding binary data in "native order"
rather than explicitly specifying endianness?**

Reading data in native order will leave it up to the operating system to decide
the endianness of the encoded values. Most file formats explicitly specify
endianness for encoded data, so it isn't practical to rely on system defaults
when processing most binary data. 

Generally speaking you should always be explicit about endianness, but one
exception might be if you were writing a binary serialization mechanism for 
use on a single machine, without having to worry about portability. Even
then, it may pay to be explicit just for the sake of consistency.

**Q7: Suppose you want to know the RGB values for the third pixel
in a bitmap image. If you know that the pixel array begins 54 bytes
into the file, and each pixel consists of 3 bytes of data, what
is the minimum amount of data you would need to read from the
file to get this information (in bytes)? Briefly explain the 
reason behind your answer.**

Only 3 bytes would need to be read.

Knowing the pixel array started 54 bytes into the file and that
the size of a pixel is three bytes, you'd trivially be able to
compute the starting position of the third pixel:

54 bytes + (2 pixels * 3 bytes) = 60 bytes.

Using this knowledge, you can directly seek 60 bytes into the file using the
`IO#pos=` method, and then use `IO#read` to grab exactly 3 bytes from the stream.

Putting it all together, you'd end up with code that looked something like this:


```ruby
pixel_size   = 3
array_offset = 54

index = 2 # zero-based, like a Ruby array.

File.open("image.bmp", "rb") do |io|
  io.pos = array_offset + (pixel_size * index)
  p io.read(pixel_size).bytes
end
```

This kind of byte math is extremely common in binary files, and is part of what
makes them an especially efficient storage format: You do not need to read in
the whole structure to be able to meaningfully traverse the data.

**Q8: Why do some binary file formats (including BMP images) pad binary data to
align with word boundaries (i.e. 4 byte chunks)? What is the cost of
organizing things this way?**

This design decisions has to do with how data is arranged and accessed 
in memory. If a CPU is optimized to handle data in 4 byte chunks, aligning
data along 4-byte word boundaries will result in a performance optimization
because fewer computations are needed to access and read the data.

There is a [long wikipedia article on this topic][data-alignment], which may 
be worth reading if this topic interests you. However, it's safe to say this 
is an extremely low-level optimization that you won't need to think about
much unless you're designing binary file formats yourself.

**Q9: Why are basic validations so important when processing binary 
file formats? What are some examples of simple validations that can help you
ensure the consistency of a binary file?**

When working with binary streams, if an offset is miscalculated by even
a single byte, all the data you read from the stream can end up being 
garbage. Sometimes this will result in exceptions being raised, but
more often than not you'll simply get bad and confusing data back.
Similarly, if you make trivial mistakes when writing out binary data to
a file, it can lead to the entire contents being unreadable.

Trivial validations such as the following can be extremly helpful in preventing
corruption and catching unexpected bugs:

* Checking for the correct file signature that identifies the format
* Verifying that the file size matches what was expected
* Making sure that offsets provided in file metadata actually match
the offsets you end up at when consuming the I/O stream.
* Raising exceptions when various kinds of metadata contain unexpected
values, or when a file format is using features your code does not
implement.

The key is to add enough validations to avoid undefined behavior. You
can develop these incrementally based on the kinds of problems you
run into while developing your code, but at least some sanity checks
should be added as early as possible.

**Q10: Name three advantages and three disadvantages of using binary file
formats vs. using text-based file formats. Try to give specific examples
where possible.**

Good things about binary file formats:

* Binary files are a very efficient data storage format, in both
time and space. The example of reading a single pixel from a BMP
file gives an example of the kind of efficiency binary files can 
afford.

* Binary files can be very simple and unambiguous to process,
because they are based on well defined basic arithmetic rules.
The MessagePack data format that is covered in the exercises
for this course show a good example of how easy binary files
can be to process.

* Due to their simplicity, binary file formats can be easily processed 
using very primitive language tools. Where a text-based format may need a
complicated regular expression engine or a parser generator, a binary file
can be processed using basic I/O operations and boolean math.

Bad things about binary file formats:

* It is very cumbersome to directly manipulate data stored
in binary format, and unless you are very comfortable with
working on binary files, they are difficult to visually
inspect, too. A hex editor is not exactly a user friendly
interface to data.

* Tiny processing errors can make the data in a binary file
completely unreadable. This is also true about text formats,
but the opaque nature of binary file formats make it harder
to debug these problems without building additional 
debugging tools.

* Thinking at a very low level is difficult for people who tend 
to work on application programming in their day to day work.
This can raise the learning curve for those who aren't used
to doing bit math in their day-to-day work.

It's worth mentioning that these pros and cons are all dependent on 
context. Text files and binary files each have their use cases,
and so there is no need to choose one style over the other, as
long as you are aware of what the tradeoffs are between the
two styles of data storage.

[endianness]: http://en.wikipedia.org/wiki/Endianness
[data-alignment]: http://en.wikipedia.org/wiki/Data_structure_alignment
