# A somewhat modified version of the calculator exampe from the Racc project.
# ORIGINAL SOURCE: https://raw.githubusercontent.com/tenderlove/racc/master/sample/calc.y

class Calcp
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
rule
  target: exp
        | /* none */ { result = 0 }

  exp: exp '+' exp { result += val[2] }
     | exp '-' exp { result -= val[2] }
     | exp '*' exp { result *= val[2] }
     | exp '/' exp { result /= val[2] }
     | '(' exp ')' { result = val[1] }
     | '-' number  =UMINUS { result = -val[1] }
     | number

   number: fraction 
         | variable
         | NUMBER

  variable: VARIABLE { result = fetch(val[0]) }

  fraction: NUMBER '\\' NUMBER { result = Rational(val[0], val[2]) } 
end

---- header

require "strscan"

---- inner

  def initialize(params={})
    @params = params
  end

  def fetch(key)
    @params.fetch(key)
  end
  
  def parse(str)
    @ss = StringScanner.new(str)

    do_parse
  end

  def next_token
    @ss.skip(/\s+/)
    return if @ss.eos?

    case
    when @ss.scan(/[a-zA-Z_]+/)
      [:VARIABLE, @ss.matched.to_sym]
    when @ss.scan(/\A\d+\.\d+/)
      [:NUMBER, @ss.matched.to_f]
    when @ss.scan(/\A\d+/)
      [:NUMBER, @ss.matched.to_i]
    else
      char = @ss.getch

      [char, char]
    end
  end

---- footer

if __FILE__ == $PROGRAM_NAME
  parser = Calcp.new
  puts
  puts 'type "Q" to quit.'
  puts
  while true
    puts
    print '? '
    str = gets.chop!
    break if /q/i =~ str
    begin
      puts "= #{parser.parse(str)}"
    rescue ParseError
      puts $!
    end
  end
end
