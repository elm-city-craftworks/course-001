require 'date'

module MsgPack
  EXTENDED_TYPES = {
    Symbol => {
      dump: %i[to_s],
      load: -> s { s.to_sym }
    },
    Bignum => {
      dump: %i[to_s],
      load: -> s { Integer(s) }
    },
    Module => {
      dump: %i[to_s],
      load: -> s { s.split('::').inject(Object, :const_get) }
    },
    Encoding => {
      dump: %i[to_s],
      load: -> s { Encoding.find(s) }
    },
    String => {
      dump: %i[encoding b],
      load: -> e,s { s.force_encoding(e) }
    },
    Range => {
      dump: %i[begin end exclude_end?],
      load: -> b,e,x { Range.new(b,e,x) }
    },
    Rational => {
      dump: %i[numerator denominator],
      load: -> n,d { Rational(n,d) }
    },
    Complex => {
      dump: %i[real imag],
      load: -> r,i { Complex(r,i) }
    },
    Regexp => {
      dump: %i[source options],
      load: -> s,o { Regexp.new(s,o) }
    },
    Time => {
      dump: %i[to_i subsec utc_offset],
      load: -> t,s,o { Time.at(t+s).getlocal(o) }
    },
    Date => {
      dump: %i[jd start],
      load: -> j,s { Date.jd(j,s) }
    },
    DateTime => {
      dump: %i[jd hour min sec sec_fraction offset start],
      load: -> j,h,m,sec,f,o,s { DateTime.jd(j,h,m,sec+f,o,s) }
    },
    Struct => {
      dump: %i[class to_h],
      load: -> c,h { c.new.tap { |s| h.each_pair { |k,v| s[k] = v } } }
    },
    Method => {
      dump: %i[receiver name],
      load: -> r,n { r.method(n) }
    },
    UnboundMethod => {
      dump: %i[owner name],
      load: -> o,n { o.instance_method(n) }
    },
  }
  TYPE2EXT = EXTENDED_TYPES.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
