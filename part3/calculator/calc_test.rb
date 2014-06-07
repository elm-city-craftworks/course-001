require "minitest/autorun"
require_relative "calc"

describe "Calculator" do
  let(:parser) { Calcp.new }

  it "can handle basic integer math" do
    parser.parse("1 + 1").must_equal(2)
    parser.parse("(2 + 3) * 5").must_equal(25)
    parser.parse("-5 * 3").must_equal(-15)
    parser.parse("(9 - 3) / 2").must_equal(3)
  end
end
