module MsgPack
  EXTENDED_TYPES_STR = { # class => unpack from string (by #to_s)
    Symbol => -> str { str.to_sym },
    Bignum => -> str { Integer(str) },
    Class  => -> str { str.split('::').inject(Object, :const_get) },
  }
  EXTENDED_TYPES_NESTED = {
    Rational => {
      pack: -> r { [r.numerator, r.denominator] },
      unpack: -> ary { Rational(*ary) }
    },
  }
  TYPE2EXT = EXTENDED_TYPES_STR.keys + EXTENDED_TYPES_NESTED.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
