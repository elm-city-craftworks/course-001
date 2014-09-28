module Packer
  class Serializer
    def initialize
      @bytes = []
    end

    def serialize(obj)
      pack(obj)
      @bytes
    end

    def pack(obj)
      case obj
      when Hash then pack_hash(obj)
      when String then pack_string(obj)
      when Fixnum then pack_fixnum(obj)
      when TrueClass then pack_true
      when FalseClass then pack_false
      when NilClass then pack_nil
      when Float then pack_float(obj)
      when Symbol then pack_symbol(obj)
      else raise "Unknown type #{obj.class.name}"
      end
    end

    def pack_hash(hash)
      raise NotImplementedError, "Max 15 elements" if hash.size > 15
      @bytes << (0x80 | hash.size)
      hash.each_pair do |k,v|
        pack(k)
        pack(v)
      end
    end

    def pack_string(s)
      is_valid_utf8 = s.dup.force_encoding("UTF-8").valid_encoding?

      raise NotImplementedError, "String must be UTF-8 encoded" unless is_valid_utf8
      raise NotImplementedError, "Max 31 chars" if s.length > 31

      @bytes << (0xa0 | s.size)
      @bytes += s.bytes.to_a
    end

    def pack_fixnum(n)
      raise NotImplementedError, "Only 0-127 supported" unless (0..127).include?(n)
      @bytes << n
    end

    def pack_true
      @bytes << 0xc3
    end

    def pack_false
      @bytes << 0xc2
    end

    def pack_nil
      @bytes << 0xc0
    end

    def pack_float(f)
      @bytes << 0xcb
      @bytes += [f].pack("G").bytes.to_a
    end

    def pack_symbol(sym)
      raise NotImplementedError, "Max symbol size is 127 chars" if sym.to_s.size > 127

      # This magic number should be shared between packer and unpacker
      type = 0x01

      @bytes << 0xc7
      @bytes << sym.size
      @bytes << type
      @bytes += sym.to_s.bytes.to_a
    end
  end

  # This method takes primitive Ruby objects and converts them into
  # the equivalent byte array in MessagePack format.
  def self.pack(obj)
    Serializer.new.serialize(obj)
  end
end

# --------------------------------------------------------------------
# Run the following tests by executing this file.

if __FILE__ == $PROGRAM_NAME
  data     = {"a"=>1, "b"=>true, "c"=>false, "d"=>nil, "egg"=>1.35}
  expected = File.binread(File.dirname(__FILE__) + "/example.msg").bytes
  actual = Packer.pack(data)

  # I had to add #to_a here to make it work
  if expected.to_a == actual.to_a
    puts "You packed the message correctly!"
  else
    # NOTE: Will output bytes in hexadecimal format for easier inspection,
    # feel free to tweak as needed.
    abort "Packed message is not what was expected.\n\n" +
          "expected output:\n[ #{expected.map { |e| "%.2x" % e }.join(" ")} ]\n\n" +
          "actual output:\n[ #{actual.map { |e| "%.2x" % e }.join(" ")} ]\n"
  end
end
