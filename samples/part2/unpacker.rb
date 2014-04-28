module Unpacker
  class Reader
    def initialize(bytes)
      @bytes = bytes
    end

    def unpack
      type_byte = @bytes.peek
      case
      when (type_byte & 0xcb) == 0xcb then unpack_float64
      when (type_byte & 0xc3) == 0xc3 then unpack_bool(true)
      when (type_byte & 0xc2) == 0xc2 then unpack_bool(false)
      when (type_byte & 0xc0) == 0xc0 then unpack_nil
      when (type_byte & 0xa0) == 0xa0 then unpack_fixstr
      when (type_byte & 0x80) == 0x80 then unpack_fixmap
      when type_byte < 0x80 then unpack_positive_fixint
      else raise "Unknown type %.2x" % type_byte
      end
    end

    private

    def unpack_fixstr
      length = 0x1f & @bytes.next
      s = ""
      length.times do
        s << @bytes.next
      end
      s
    end

    def unpack_fixmap
      num_items = @bytes.next & 0x0F

      hash = {}
      num_items.times do
        key = unpack
        value = unpack

        hash[key] = value
      end
      hash
    end

    def unpack_positive_fixint
      @bytes.next
    end

    def unpack_bool(value)
      @bytes.next
      value
    end

    def unpack_nil
      @bytes.next
      nil
    end

    def unpack_float64
      bin = ""
      @bytes.next
      8.times do
        bin << @bytes.next
      end
      bin.unpack("G").first
    end
  end


  class << self
    # This method takes a sequence of bytes in message pack format and convert
    # it into an equivalent Ruby object
    def unpack(bytes)
      Reader.new(bytes).unpack
    end
  end

end

# --------------------------------------------------------------------
# Run the following tests by executing this file.

if __FILE__ == $PROGRAM_NAME
  data     = File.binread(File.dirname(__FILE__) + "/example.msg").each_byte
  expected = {"a"=>1, "b"=>true, "c"=>false, "d"=>nil, "egg"=>1.35}

  actual = Unpacker.unpack(data)

  if actual == expected
    puts "You unpacked the message correctly!"
  else
    abort "Unpacked message is not what was expected.\n\n" +
          "expected output:\n#{expected.inspect}\n\n" +
          "actual output:\n#{actual.inspect}"
  end
end
