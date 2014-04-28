module Unpacker
  class Reader
    def initialize(bytes)
      @bytes = bytes
    end

    def unpack
      case
      when is_type?(0xcb) then unpack_float64
      when is_type?(0xc3) then unpack_simple(true)
      when is_type?(0xc2) then unpack_simple(false)
      when is_type?(0xc0) then unpack_simple(nil)
      when is_type?(0xa0) then unpack_fixstr
      when is_type?(0x80) then unpack_fixmap
      else unpack_positive_fixint
      end
    end

    private
    def is_type?(type_byte)
      (@bytes.peek & type_byte) == type_byte
    end

    def read_bytes(num, &block)
      "".tap { |s|
        num.times do
          byte = next_byte
          s << byte
          block.call(byte) if block
        end
      }
    end

    def next_byte
      @bytes.next
    end

    def unpack_fixstr
      length = 0x1f & next_byte

      "".tap { |s|
        read_bytes(length) do |b|
          s << b
        end
      }
    end

    def unpack_fixmap
      num_items = next_byte & 0x0F

      num_items.times.each_with_object({}) do |_, hash|
        key = unpack
        value = unpack

        hash[key] = value
      end
    end

    def unpack_simple(value)
      next_byte
      value
    end

    def unpack_positive_fixint
      next_byte
    end

    def unpack_float64
      next_byte
      read_bytes(8).unpack("G").first
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
