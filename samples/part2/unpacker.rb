module Unpacker
  class Reader
    def initialize(bytes)
      @bytes = bytes
    end

    def unpack
      type_byte = @bytes.peek
      case
      when type_byte & 0x80 > 0 then unpack_fixmap
      else raise "Unknown type %.2x" % type_byte
      end
    end

    private

    def unpack_fixmap
      puts "fixmap"
      num_items = @bytes.next & 0x0F
      num_items.times.map { unpack }
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
