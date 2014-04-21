require_relative 'msgpack'

module Packer
  extend self
  include MsgPack

  def pack(obj)
    case obj
    when NilClass then [0xc0]
    when TrueClass then [0xc3]
    when FalseClass then [0xc2]
    when Fixnum, Bignum
      case obj
      when 0...128
        [obj]
      when -32..-1
        [256 + obj]
      when 128...(1 << 64)
        n = 0
        n += 1 while obj >= (1 << (8 * (1 << n)))
        [0xcc+n] + [obj].pack(UINT_PACK_DIRECTIVES[n].upcase).bytes
      when -(1 << 63)...-32
        n = 0
        n += 1 while obj < -(1 << (8 * (1 << n) - 1))
        [0xd0+n] + [obj].pack(INT_PACK_DIRECTIVES[n]).bytes
      else # Bignum
        dump_ext(Bignum, obj.to_s.bytes)
      end
    when Float
      [0xcb] + [obj].pack('G').bytes
    when String
      case obj.encoding
      when Encoding::BINARY
        raise if obj.bytesize > 256
        [0xc4, obj.bytesize] + obj.bytes
      when Encoding::US_ASCII, Encoding::UTF_8
        case obj.bytesize
        when 0...32
          [0xa0 + obj.bytesize] + obj.bytes
        when 32...256
          [0xd9, obj.bytesize] + obj.bytes
        end or raise obj.bytesize.to_s
      else
        dump_ext(String, pack(obj.encoding) + pack(obj.b))
      end
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
    when *EXTENDED_TYPES.keys # Nice, isn't it?
      klass = obj.class.ancestors.find { |klass| EXTENDED_TYPES[klass] }
      ary = (dump = EXTENDED_TYPES[klass][:dump]).map { |e| obj.send(e) }
      bytes = (dump == [:to_s]) ? ary[0].bytes : ary.map { |e| pack(e) }.reduce([], :+)
      dump_ext(klass, bytes)
    else
      raise "Unknown type: #{obj.class}"
    end
  end

private
  def dump_ext(klass, data)
    size = data.size
    raise "Do not know how to dump #{klass} of length #{size}" if size > 0xFF
    if i = [1, 2, 4, 8, 16].index(size)
      [0xd4+i, EXT2TYPE[klass]] + data
    else
      [0xc7, size, EXT2TYPE[klass]] + data
    end
  end
end
