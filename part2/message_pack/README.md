TODO: Document Step 1 answer (show hexdump and explain)

**unpacker.rb** (view source)

Takes a sequence of bytes in MessagePack format and converts 
it to an equivalent Ruby object. Covers a minimal subset
of MessagePack types, and also implements storage of
Ruby symbols via the extended type mechanism.

An acceptance test script is included within this file.

**packer.rb** (view source)

Takes a Ruby hash and converts it to an array of
bytes in MessagePack format. This only implements
a small subset of the types of data that can be encoded 
in MessagePack. For a much more comprehensive solution,
see Benoit Daloze's submission.

An acceptance test script is included within this file.

**extended_messages.rb** (view source)

An acceptance test to verify that Ruby symbols can
be packed and unpacked in MessagePack format.

**unicode_messages.rb** (view source)

An acceptance test to verify that multibyte unicode characters 
are supported by the Packer and Unpacker modules.
