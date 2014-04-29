# coding: binary

module Unpacker
  SYMBOL_TYPE = 1

  # FIXME: What validations would be needed to make sure this code either
  # always works correctly, or fails with an appropriate error?

  # This method takes a sequence of bytes in message pack format and convert 
  # it into an equivalent Ruby object
  def self.unpack(bytes)
    case code = bytes.next
    when 0x00 .. 0x7f
      code
    when 0x80 .. 0x8f
      len = code & 0x0f

      len.times.with_object({}) { |_,e| e[unpack(bytes)] = unpack(bytes) }
    when 0xa0..0xbf
      len = code & 0b000_11111

      len.times.map { bytes.next }.pack("U*")
    when 0xc0
      nil
    when 0xc2
      false
    when 0xc3
      true
    when 0xcb
      8.times.map { bytes.next }.pack("C*").unpack("G").first
    when 0xc7
      size = bytes.next
      type = bytes.next
      
      case type
      when SYMBOL_TYPE
        size.times.map { bytes.next }.pack("U*").to_sym
      else
        raise NotImplementedError
      end
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
