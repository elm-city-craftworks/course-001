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

def test_and_compare(input)
  require 'msgpack' # gem
  packed = Packer.pack(input)

  msgpack = input.to_msgpack.bytes
  unless msgpack == packed
    abort "bad msgpack format, expected:\n" +
          msgpack.inspect + "\n" +
          "and not:\n" +
          packed.inspect
  end

  test(input)
end

test_and_compare({ "a" => 1, "b" => true, "c" => false, "d" => nil, "egg" => 1.35 })

test({ :foo => 2, :bar => 4 })

test([1, "a", 3.14])

bignum = 1 << 65
test(bignum)

test_and_compare(-6)

test_and_compare(164)

test_and_compare(-42)

test(Rational(-2,3))

some_class = Fixnum
test(some_class)

Coord = Struct.new(:x, :y)
coord = Coord.new(21, -4)

test(coord)

test(Complex(-2,3))
