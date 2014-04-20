module MsgPack
  TYPE2EXT = [ Symbol ]
  EXT2TYPE = Hash[TYPE2EXT.each_with_index.to_a]
end
