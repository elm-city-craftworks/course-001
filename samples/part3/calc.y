# Very simple calculator, from the Racc project.
# SOURCE: https://raw.githubusercontent.com/tenderlove/racc/master/sample/calc.y

class Calcp
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
rule
  target: exp

  exp: exp '+' exp { result += val[2] }
     | exp '-' exp { result -= val[2] }
     | exp '*' exp { result *= val[2] }
     | exp '/' exp { result /= val[2] }
     | '(' exp ')' { result = val[1] }
     | '-' exp =UMINUS { result = -val[1] }
     | TERM
end

---- header
# $Id$
require 'strscan'
---- inner
  attr_reader :ss, :env
  def initialize(env = {})
    @env = env
  end

  def parse(str)
    @ss = StringScanner.new str
    do_parse
  end

  def next_token
    return if ss.eos?
    ss.skip(/\s+/)

    if n = ss.scan(/\d+(?:\.\d+)?/)
      [:TERM, Rational(n)]
    elsif var = ss.scan(/\w+/)
      n = env[var.to_sym] or raise ParseError, "unknown var #{var}"
      [:TERM, Rational(n)]
    elsif s = ss.getch
      [s, s]
    end
  end

---- footer

parser = Calcp.new(:x => 10, :y => 15, :z => 3)
while str = (print "\n? "; gets)
  begin
    puts "= #{parser.parse(str)}"
  rescue ParseError
    puts $!
  end
end
