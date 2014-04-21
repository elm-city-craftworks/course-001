require 'date'

module MsgPack
  EXTENDED_TYPES_STR = { # class => load from string (by #to_s)
    Symbol => -> str { str.to_sym },
    Bignum => -> str { Integer(str) },
    Module  => -> str { str.split('::').inject(Object, :const_get) },
  }
  EXTENDED_TYPES_ARY = {
    Range => {
      dump: -> r { [r.begin, r.end, r.exclude_end?] },
      load: -> b,e,x { Range.new(b,e,x) }
    },
    Rational => {
      dump: -> r { [r.numerator, r.denominator] },
      load: -> n,d { Rational(n,d) }
    },
    Complex => {
      dump: -> c{ [c.real, c.imag] },
      load: -> r,i { Complex(r,i) }
    },
    Regexp => {
      dump: -> r { [r.source, r.options] },
      load: -> s,o { Regexp.new(s,o) }
    },
    Time => {
      dump: -> t { [t.to_i + t.subsec, t.utc_offset] },
      load: -> t,o { Time.at(t).getlocal(o) }
    },
    Date => {
      dump: -> d { [d.jd, d.start] },
      load: -> j,s { Date.jd(j,s) }
    },
    DateTime => {
      dump: -> d { [d.jd, d.hour, d.min, d.sec + d.sec_fraction, d.offset, d.start] },
      load: -> j,h,m,sec,o,s { DateTime.jd(j,h,m,sec,o,s) }
    },
    Struct => {
      dump: -> s { [s.class, s.to_h] },
      load: -> c,h { c.new.tap { |s| h.each_pair { |k,v| s[k] = v } } }
    },
    Method => {
      dump: -> m { [m.receiver, m.name] },
      load: -> r,n { r.method(n) }
    },
    UnboundMethod => {
      dump: -> m { [m.owner, m.name] },
      load: -> o,n { o.instance_method(n) }
    },
  }
  TYPE2EXT = EXTENDED_TYPES_STR.keys + EXTENDED_TYPES_ARY.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
