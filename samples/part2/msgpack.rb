module MsgPack
  TYPE2EXT = [ Symbol, Bignum ]
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
