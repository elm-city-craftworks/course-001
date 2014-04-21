require 'date'

module MsgPack
  EXTENDED_TYPES_STR = { # class => unpack from string (by #to_s)
    Symbol => -> str { str.to_sym },
    Bignum => -> str { Integer(str) },
    Module  => -> str { str.split('::').inject(Object, :const_get) },
  }
  EXTENDED_TYPES_NESTED = {
    Range => {
      pack: -> r { [r.begin, r.end, r.exclude_end?] },
      unpack: -> ary { Range.new(*ary) }
    },
    Rational => {
      pack: -> r { [r.numerator, r.denominator] },
      unpack: -> ary { Rational(*ary) }
    },
    Complex => {
      pack: -> r { [r.real, r.imag] },
      unpack: -> ary { Complex(*ary) }
    },
    Regexp => {
      pack: -> r { [r.source, r.options] },
      unpack: -> ary { Regexp.new(*ary) }
    },
    Time => {
      pack: -> t { [t.to_i + t.subsec, t.utc_offset] },
      unpack: -> ((t,o)) { Time.at(t).getlocal(o) }
    },
    Date => {
      pack: -> d { [d.jd, d.start] },
      unpack: -> ary { Date.jd(*ary) }
    },
    DateTime => {
      pack: -> d { [d.jd, d.hour, d.min, d.sec + d.sec_fraction, d.offset, d.start] },
      unpack: -> ary { DateTime.jd(*ary) }
    },
    Struct => {
      pack: -> s { [s.class, s.to_h] },
      unpack: -> ((c,h)) { c.new.tap { |s| h.each_pair { |k,v| s[k] = v } } }
    },
    Method => {
      pack: -> m { [m.receiver, m.name] },
      unpack: -> ((r,n)) { r.method(n) }
    },
    UnboundMethod => {
      pack: -> m { [m.owner, m.name] },
      unpack: -> ((o,n)) { o.instance_method(n) }
    },
  }
  TYPE2EXT = EXTENDED_TYPES_STR.keys + EXTENDED_TYPES_NESTED.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
