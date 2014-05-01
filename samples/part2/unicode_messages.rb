# coding: UTF-8

require_relative "packer"
require_relative "unpacker"

## FIXME: Edit packer.rb and unpacker.rb as needed to pass this test. 
# You will need to make sure strings are treated as UTF-8

input = { "Ĕ" => true }
output = Unpacker.unpack(Packer.pack(input).each)

if output["Ĕ"]
  puts "UTF-8 multibyte chars works correctly!"
else
  abort "UTF-8 multibyte chars did not work as expected\n\n" +
        "After packing and unpacking, got this:\n\n" +
        output.inspect +
        "\n\nExpected this instead:\n\n" +
        input.inspect
end

