require_relative "packer"
require_relative "unpacker"

EQ = Hash.new { |h,k| -> a, b { a == b } }

EQ[String] = -> a, b { a == b and a.encoding == b.encoding }
EQ[Time] = -> a, b { a == b and a.utc_offset == b.utc_offset }
EQ[Date] = -> a, b { a == b and a.start == b.start }
EQ[DateTime] = -> a, b { EQ[Date][a,b] and a.offset == b.offset }

def hexdump(bytes)
  "[" << bytes.map { |b| "%02x" % b }.join(" ") << "]"
end

def test(input)
  output = Unpacker.unpack(Packer.pack(input).each)

  print input.inspect
  if EQ[input.class].call(input, output)
    puts " Round-trip OK"
  else
    raise "\n\nFailed Round-trip\n\n" +
          "After packing and unpacking, got this:\n\n" +
          output.inspect
  end
end

def test_and_compare(input)
  require 'msgpack' # gem
  packed = Packer.pack(input)

  msgpack = input.to_msgpack.bytes
  unless msgpack == packed
    raise "bad msgpack format for #{input.inspect}, expected:\n" +
          hexdump(msgpack) + "\n" +
          "and not:\n" +
          hexdump(packed)
  end

  test(input)
end

test_and_compare({ "a" => 1, "b" => true, "c" => false, "d" => nil, "egg" => 1.35 })

test({ :foo => 2, :bar => 4 })

test([1, "a", 3.14])

test("hello")
test("hello".b)
test("hello".encode(Encoding::UTF_8))
test("hello".encode(Encoding::ISO_8859_1))

bignum = 1 << 65
test(bignum)

test_and_compare(-6)

test_and_compare(164)

test_and_compare(-42)

test_and_compare(1 << 18)
test_and_compare(1 << 36)

(0..65).each { |i|
  n = (1 << i)

  [-n-1, -n, -n+1, n-1, n, n+1].each do |int|
    if (-(1 << 63)...(1 << 64)).include? int
      test_and_compare int
    else
      test int
    end
  end
}

test(-1..3)
test(-1...4)
test("Hello".."TheEnd")

test(Rational(-2,3))

some_class = Fixnum
test(some_class)
test(Enumerable)

Coord = Struct.new(:x, :y)
coord = Coord.new(21, -4)

test(coord)

test(Complex(-2,3))

test(/abc/)
test(/abc/i)

test(Time.now)
test(Time.now.utc)

test(Date.new)
test(Date.today)
test(Date.today.new_start(Date::ENGLAND))

test(DateTime.now)
test(DateTime.now(Date::ENGLAND))

test(3.method(:+))

test(String.instance_method(:chomp))

test(Encoding::ISO_8859_1)
