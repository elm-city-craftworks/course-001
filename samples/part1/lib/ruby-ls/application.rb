module RubyLS
  class Application
    def initialize(argv)
      @params, @dirs = parse_options(argv)
      @display       = RubyLS::Display.new(@params)
    end

    def run
      @display.render(@dirs)
    end

    def parse_options(argv)
      params = {}
      parser = OptionParser.new

      parser.on("-l") { params[:display_format] = :long }
      parser.on("-a") { params[:show_hidden]    = true }

      begin
        dirs = parser.parse(argv)
      rescue OptionParser::InvalidOption
        $stderr.puts "ls: illegal option -- #{argv[0][1]}"
        $stderr.puts "usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]"
        exit(1)
      end

      [params, dirs]
    end
  end
end
