require_relative "packer"
require_relative "unpacker"

def test(input)
  output = Unpacker.unpack(Packer.pack(input).each)

  print input.inspect
  if input == output
    puts " Round-trip OK"
  else
    abort "Failed Round-trip\n\n" +
          "After packing and unpacking, got this:\n\n" +
          output.inspect
  end
end

test([1, "a", 3.14])

bignum = 1 << 65
test(bignum)

test(-6)
