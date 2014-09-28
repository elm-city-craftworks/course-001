require 'delegate'

module Unpacker
  class ByteReader < SimpleDelegator
    # Is there an easier way to do this using library methods?
    def read(num)
      bytes = []
      num.times do
        bytes << self.next
      end
      bytes.pack("C*")
    end

    def current
      peek
    end

    def skip
      self.next
      nil
    end
  end

  class Deserializer
    def initialize(bytes)
      @in = ByteReader.new(bytes)
    end

    def unpack
      case
      when is_type?(0xcb) then unpack_float64
      when is_type?(0xc7) then unpack_extension
      when is_type?(0xc3) then unpack_simple(true)
      when is_type?(0xc2) then unpack_simple(false)
      when is_type?(0xc0) then unpack_simple(nil)
      when is_type?(0xa0) then unpack_fixstr
      when is_type?(0x80) then unpack_fixmap
      else unpack_positive_fixint
      end
    end

    def unpack_float64
      @in.skip
      @in.read(8).unpack("G").first
    end

    def unpack_extension
      converters = {
        # These magic numbers should be shared between packer and unpacker
        0x01 => ->(bytes) { bytes.to_sym }
      }

      @in.skip
      size = @in.next
      type = @in.next

      converter = converters.fetch(type) { raise "Unknown extension type %.2x" % type }

      converter.call(@in.read(size))
    end

    def is_type?(type_byte)
      # Not sure if I'm using bitwise logic correctly here.
      (@in.current & type_byte) == type_byte
    end

    def unpack_fixstr
      length = @in.next & 0x1f
      s = @in.read(length)
      unless s.force_encoding("UTF-8").valid_encoding?
        raise "Invalid encoding"
      end
      s
    end

    def unpack_fixmap
      num_pairs = @in.next & 0x0F
      num_pairs.times.each_with_object({}) do |_, res|
        key, value = unpack, unpack
        res[key] = value
      end
    end

    def unpack_simple(value)
      @in.skip
      value
    end

    def unpack_positive_fixint
      @in.next
    end
  end

  class << self
    # This method takes a sequence of bytes in message pack format and convert
    # it into an equivalent Ruby object
    def unpack(bytes)
      Deserializer.new(bytes).unpack
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
