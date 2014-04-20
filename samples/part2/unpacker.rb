require_relative 'msgpack'

module Unpacker
  extend self

  # This method takes an array of bytes in message pack format and convert
  # it into an equivalent Ruby object
  def unpack(bytes)
    type = bytes.next
    case type
    when 0x00..0x7f then type
    when 0xa0..0xbf
      unpack_str(type - 0xa0, bytes).force_encoding('UTF-8')
    when 0xc0 then nil
    when 0xc2 then false
    when 0xc3 then true
    when 0xcb
      unpack_str(8, bytes).unpack('G')[0]
    when 0xc7 then
      size = bytes.next
      type = bytes.next
      if MsgPack::TYPE2EXT[type] == Symbol
        unpack_str(size, bytes).to_sym
      else
        raise "Unknown extended type #{type.to_s(16)}"
      end
    when 0x80..0x8f
      (type - 0x80).times.with_object({}) { |_,map|
        map[unpack(bytes)] = unpack(bytes)
      }
    when 0x90..0x9f
      (type - 0x90).times.with_object([]) { |_,ary|
        ary << unpack(bytes)
      }
    else
      raise "Unknown msgpack type: #{type.to_s(16)}"
    end
  end

private
  def unpack_str(bytesize, bytes)
    bytesize.times.with_object("".b) { |_,str|
      str << bytes.next
    }
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
