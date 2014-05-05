TODO: Document Step 1 answer (show hexdump and explain)

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
