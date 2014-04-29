# coding: binary

module Packer
  SYMBOL_TYPE_ID = 1

  # This method takes primitive Ruby objects and converts them into
  # the equivalent byte array in MessagePack format.
  def self.pack(obj)
    case obj
    when Hash
      raise NotImplementedError unless obj.size < 16

      bytes = [0x80 + obj.length] 

      obj.each do |k,v|
        bytes.concat(pack(k))
        bytes.concat(pack(v))
      end

      bytes
    when Fixnum
      raise NotImplementedError unless obj <= 0x7f

      [obj]
    when true
      [0xc3]
    when false
      [0xc2]
    when nil
      [0xc0]
    when String
      raise NotImplementedError unless obj.bytes.size < 32

      [0xa0 + obj.bytes.size] + obj.bytes
    when Float
      [0xcb] + [obj].pack("G").unpack("C*")
    when Symbol
      bytes = obj.to_s.bytes

      [0xc7, bytes.size, SYMBOL_TYPE_ID] + bytes
    else
      [0xff]
    end
  end
end

# --------------------------------------------------------------------
# Run the following tests by executing this file.

if __FILE__ == $PROGRAM_NAME 
  data     = {"a"=>1, "b"=>true, "c"=>false, "d"=>nil, "egg"=>1.35}
  expected = File.binread(File.dirname(__FILE__) + "/example.msg").bytes

  actual = Packer.pack(data) 

  if expected == actual
    puts "You packed the message correctly!"
  else
    # NOTE: Will output bytes in hexadecimal format for easier inspection,
    # feel free to tweak as needed.
    abort "Packed message is not what was expected.\n\n" +
          "expected output:\n[ #{expected.map { |e| "%.2x" % e }.join(" ")} ]\n\n" +
          "actual output:\n[ #{actual.map { |e| "%.2x" % e }.join(" ")} ]\n"
  end
end
