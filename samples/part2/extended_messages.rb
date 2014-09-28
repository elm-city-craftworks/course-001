require_relative "packer"
require_relative "unpacker"

input = { :foo => 2, :bar => 4 }

# puts Packer.pack(input).map { |b| "%.2x" % b }.join(" ")

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
