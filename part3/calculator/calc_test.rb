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

  it "can handle floating point math" do
    parser.parse("1.5 + 3").must_equal(4.5)
  end

  it "can handle rational math" do
    parser.parse("1\\3 + 1\\6").must_equal(Rational(1,2)) 
  end

  it "can handle bound variables" do
    parser = Calcp.new(:x => 10, :y => 15, :z => 3)

    parser.parse("x + 5").must_equal(15)
    parser.parse("x * y * z").must_equal(450)
    parser.parse("(x + y) * 2").must_equal(50)
  end
end