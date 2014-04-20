require_relative "packer"
require_relative "unpacker"

## FIXME: Edit packer.rb and unpacker.rb as needed to pass this test.
# You will need to add an extension type to support symbols.
#
input = { :foo => 2, :bar => 4 }
output = Unpacker.unpack(Packer.pack(input).each)

if input == output
  puts "Extended type works correctly!"
else
  abort "Extended types did not work as expected\n\n" +
        "After packing and unpacking, got this:\n\n" +
        output.inspect +
        "\n\nExpected this instead:\n\n" +
        input.inspect
end
