module MsgPack
  EXTENDED_TYPES = { # class => unpack from string (by #to_s)
    Symbol => -> data { data.to_sym },
    Bignum => -> data { Integer(data) },
    Rational => -> data { Rational(data) },
  }
  TYPE2EXT = EXTENDED_TYPES.keys
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
