## Solution to exercises for Part 2

The first step of the exercise involved manually inspecting
a [MessagePack](https://github.com/msgpack/msgpack/blob/master/spec.md) formatted file with a hex editor to answer
some questions about it, including the size of the encoded
map, the ASCII representation of all of its keys, and the
types of each of its values.

To determine those details, we can look at the raw hex output:

```
$ xxd -g 1 example.msg
0000000: 85 a1 61 01 a1 62 c3 a1 63 c2 a1 64 c0 a3 65 67  ..a..b..c..d..eg
0000010: 67 cb 3f f5 99 99 99 99 99 9a                    g.?.......
```

In MessagePack format, a `fixmap` object has between 1 and 16 elements,
and is indicated with a header between `0x80` and `0x8f`. The very 
first byte of the file is `0x85`, and that tells us that it encodes
a fixmap object consisting of 5 key-value pairs, or a total of 10
objects.

Breaking this message up into each of the key value pairs makes it easier
to see how the file is laid out:

```
a1 61       => 01
a1 62       => c3
a1 63       => c2
a1 64       => c0
a3 65 67 67 => cb 3f f5 99 99 99 99 99 9a
```

All of the keys are `fixstr` objects in this `fixmap`, and all of the keys are single character strings except for the last one, which is three characters long. Converting the ascii codes to a character representation, we get `"a"`, `"b"`, `"c"`, `"d"`, and `"egg"` for keys.

Each of the values in this `fixmap` has a unique type, and all but the last one are represented by a single byte. Referring to the spec, it's easy to see that `0x01` maps to the `fixint` value 1, `0xc3` represents `true`, `0xc2` represents `false`, and `0xc0` represents  `nil`. From the first byte of the final value
(`0xcb`), we're able to tell that the encoded data is a floating point number. Without getting into detail about how flaots are encoded, the value represented here turns out to be `1.35`.

Putting all of this together, we have a `fixmap` object that is equivalent to the following Ruby hash:
`{"a"=>1, "b"=>true, "c"=>false, "d"=>nil, "egg"=>1.35}`. You'll see this hash used throughout the acceptance tests for this set of exercises, and now you should understand where it came from!

For the code samples related to the remaining exercises, see the following files:

**unpacker.rb** ([view source][unpacker.rb])

Takes a sequence of bytes in MessagePack format and converts 
it to an equivalent Ruby object. Covers a minimal subset
of MessagePack types, and also implements storage of
Ruby symbols via the extended type mechanism.

An acceptance test script is included within this file.

**packer.rb** ([view source][packer.rb])

Takes a Ruby hash and converts it to an array of
bytes in MessagePack format. This only implements
a small subset of the types of data that can be encoded 
in MessagePack. For a much more comprehensive solution,
see Benoit Daloze's submission.

An acceptance test script is included within this file.

**extended_messages.rb** ([view source][extended_messages.rb])

An acceptance test to verify that Ruby symbols can
be packed and unpacked in MessagePack format.

**unicode_messages.rb** ([view source][unicode_messages.rb])

An acceptance test to verify that multibyte unicode characters 
are supported by the Packer and Unpacker modules.

[unpacker.rb]: https://github.com/elm-city-craftworks/course-001/blob/solutions/part2/message_pack/unpacker.rb
[packer.rb]: https://github.com/elm-city-craftworks/course-001/blob/solutions/part2/message_pack/packer.rb
[extended_messages.rb]: https://github.com/elm-city-craftworks/course-001/blob/solutions/part2/message_pack/extended_messages.rb
[unicode_messages.rb]: https://github.com/elm-city-craftworks/course-001/blob/solutions/part2/message_pack/unicode_messages.rb
