require_relative 'msgpack'

module Packer
  extend self
  include MsgPack

  # This method takes primitive Ruby objects and converts them into
  # the equivalent byte array in MessagePack format.
  def pack(obj)
    case obj
    when NilClass then [0xc0]
    when TrueClass then [0xc3]
    when FalseClass then [0xc2]
    when Fixnum
      case obj
      when 0...128
        [obj]
      when 128...256
        [0xcc, obj]
      when 256...(1 << 16)
        [0xcd] + [obj].pack('S>').bytes
      when (1 << 16)...(1 << 32)
        [0xce] + [obj].pack('L>').bytes
      when (1 << 32)...(1 << 64)
        [0xcf] + [obj].pack('Q>').bytes
      when -31..-1
        [256 + obj]
      when -127..-32
        [0xd0, 256 + obj]
      end or raise obj.to_s
    when Float
      [0xcb] + [obj].pack('G').bytes
    when String
      raise if obj.bytesize > 31
      [0xa0 + obj.bytesize] + obj.bytes
    when Array
      raise if obj.size > 15
      obj.inject([0x90 + obj.size]) { |bytes, e|
        bytes + pack(e)
      }
    when Hash
      raise if obj.size > 15
      obj.each_pair.inject([0x80 + obj.size]) { |bytes, (key, val)|
        bytes + pack(key) + pack(val)
      }
    when *EXTENDED_TYPES_STR.keys # Nice, isn't it?
      klass = obj.class.ancestors.find { |klass| EXTENDED_TYPES_STR[klass] }
      dump_ext(obj, obj.to_s.bytes, klass)
    when *EXTENDED_TYPES_ARY.keys
      klass = obj.class.ancestors.find { |klass| EXTENDED_TYPES_ARY[klass] }
      ary = EXTENDED_TYPES_ARY[klass][:dump].map { |e| obj.send(e) }
      dump_ext(obj, ary.reduce([]) { |bytes,e| bytes + pack(e) }, klass)
    else
      raise "Unknown type: #{obj.class}"
    end
  end

private
  def dump_ext(obj, data, klass)
    size = data.size
    raise "Do not know how to dump #{obj.class} of length #{size}" if size > 0xFF
    [0xc7, size, EXT2TYPE[klass]] + data
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