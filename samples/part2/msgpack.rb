require 'date'

module MsgPack
  EXTENDED_TYPES_STR = { # class => unpack from string (by #to_s)
    Symbol => -> str { str.to_sym },
    Bignum => -> str { Integer(str) },
    Module  => -> str { str.split('::').inject(Object, :const_get) },
  }
  EXTENDED_TYPES_ARY = {
    Range => {
      pack: -> r { [r.begin, r.end, r.exclude_end?] },
      unpack: -> b,e,x { Range.new(b,e,x) }
    },
    Rational => {
      pack: -> r { [r.numerator, r.denominator] },
      unpack: -> n,d { Rational(n,d) }
    },
    Complex => {
      pack: -> c{ [c.real, c.imag] },
      unpack: -> r,i { Complex(r,i) }
    },
    Regexp => {
      pack: -> r { [r.source, r.options] },
      unpack: -> s,o { Regexp.new(s,o) }
    },
    Time => {
      pack: -> t { [t.to_i + t.subsec, t.utc_offset] },
      unpack: -> t,o { Time.at(t).getlocal(o) }
    },
    Date => {
      pack: -> d { [d.jd, d.start] },
      unpack: -> j,s { Date.jd(j,s) }
    },
    DateTime => {
      pack: -> d { [d.jd, d.hour, d.min, d.sec + d.sec_fraction, d.offset, d.start] },
      unpack: -> j,h,m,sec,o,s { DateTime.jd(j,h,m,sec,o,s) }
    },
    Struct => {
      pack: -> s { [s.class, s.to_h] },
      unpack: -> c,h { c.new.tap { |s| h.each_pair { |k,v| s[k] = v } } }
    },
    Method => {
      pack: -> m { [m.receiver, m.name] },
      unpack: -> r,n { r.method(n) }
    },
    UnboundMethod => {
      pack: -> m { [m.owner, m.name] },
      unpack: -> o,n { o.instance_method(n) }
    },
  }
  TYPE2EXT = EXTENDED_TYPES_STR.keys + EXTENDED_TYPES_ARY.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
