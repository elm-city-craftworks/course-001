module MsgPack
  EXTENDED_TYPES_STR = { # class => unpack from string (by #to_s)
    Symbol => -> str { str.to_sym },
    Bignum => -> str { Integer(str) },
    Module  => -> str { str.split('::').inject(Object, :const_get) },
  }
  EXTENDED_TYPES_NESTED = {
    Rational => {
      pack: -> r { [r.numerator, r.denominator] },
      unpack: -> ary { Rational(*ary) }
    },
    Complex => {
      pack: -> r { [r.real, r.imag] },
      unpack: -> ary { Complex(*ary) }
    },
    Struct => {
      pack: -> s { s.to_h.merge({ __class__: s.class }) },
      unpack: -> h { h.delete(:__class__).new.tap { |s| h.each_pair { |k,v| s[k] = v } } }
    },
  }
  TYPE2EXT = EXTENDED_TYPES_STR.keys + EXTENDED_TYPES_NESTED.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
