# coding: binary

module Unpacker
  SYMBOL_TYPE = 1

  class << self
    # This method takes a sequence of bytes in message pack format and convert 
    # it into an equivalent Ruby object
    def unpack(bytes)
      case code = bytes.next
      when 0x00 .. 0x7f
        code
      when 0x80 .. 0x8f
        size = code & 0x0f

        size.times.with_object({}) { |_,e| e[unpack(bytes)] = unpack(bytes) }
      when 0xa0..0xbf
        size = code & 0b000_11111

        binary_string(size, bytes).force_encoding("UTF-8")
      when 0xc0
        nil
      when 0xc2
        false
      when 0xc3
        true
      when 0xcb
        binary_string(8, bytes).unpack("G").first
      when 0xc7
        size = bytes.next
        type = bytes.next

        raise NotImplementedError unless SYMBOL_TYPE == type
        
        binary_string(size, bytes).to_sym
      end
    end

    private

    def binary_string(num, bytes)
      num.times.map { bytes.next }.pack("C*")
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
