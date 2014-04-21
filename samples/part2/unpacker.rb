require_relative 'msgpack'

module Unpacker
  extend self
  include MsgPack

  def unpack(bytes)
    type = bytes.next
    case type
    when 0x00..0x7f then type
    when 0x80..0x8f
      (type - 0x80).times.with_object({}) { |_,map|
        map[unpack(bytes)] = unpack(bytes)
      }
    when 0x90..0x9f
      (type - 0x90).times.with_object([]) { |_,ary|
        ary << unpack(bytes)
      }
    when 0xa0..0xbf
      unpack_str(type - 0xa0, bytes).force_encoding(Encoding::UTF_8)
    when 0xc0 then nil
    when 0xc2 then false
    when 0xc3 then true
    when 0xcb
      unpack_str(8, bytes).unpack('G')[0]
    when 0xcc
      bytes.next
    when 0xc4
      unpack_str(bytes.next, bytes)
    when 0xc7, 0xd4..0xd8
      size = type == 0xc7 ? bytes.next : (1 << type - 0xd4)
      type = bytes.next
      klass = TYPE2EXT[type] or
        raise "Unknown extended type #{type.to_s(16)}"
      load = EXTENDED_TYPES[klass][:load]
      if EXTENDED_TYPES[klass][:dump] == [:to_s]
        load.(unpack_str(size, bytes))
      else
        load.(*load.arity.times.map { unpack(bytes) })
      end
    when 0xcd
      unpack_str(2, bytes).unpack('S>')[0]
    when 0xce
      unpack_str(4, bytes).unpack('L>')[0]
    when 0xcf
      unpack_str(8, bytes).unpack('Q>')[0]
    when 0xd0
      bytes.next - 256
    when 0xe0..0xff
      type - 256
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
