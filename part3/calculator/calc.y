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
        | /* none */ { result = 0 }

  exp: exp '+' exp { result += val[2] }
     | exp '-' exp { result -= val[2] }
     | exp '*' exp { result *= val[2] }
     | exp '/' exp { result /= val[2] }
     | '(' exp ')' { result = val[1] }
     | '-' NUMBER  =UMINUS { result = -val[1] }
     | NUMBER
end

---- header

require "strscan"

---- inner
  
  def parse(str)
    @ss = StringScanner.new(str)

    do_parse
  end

  def next_token
    @ss.skip(/\s+/)
    return if @ss.eos?

    if @ss.scan(/\A\d+/)
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
