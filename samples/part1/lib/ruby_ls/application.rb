module RubyLs
  class Application

  	def initialize(argv)
      @options, @args = parse_options(argv)
      @dir = @args.first
      @display = RubyLs::Display.new(@options)
  	end

  	def run
      begin
        @display.render(files, directory?)
      rescue SystemCallError => e
        abort("ls: #{@dir}: No such file or directory")
      end
  	end

    private

      def parse_options(argv)
        options = {}
        parser = OptionParser.new
        parser.on("-l") {options[:detail] = true}
        parser.on("-a") {options[:hidden] = true}
        begin
          args = parser.parse(argv)
          [options, args]
        rescue OptionParser::InvalidOption => e 
          invalid_flag = e.message[/invalid option: -(.*)/, 1]
          abort "ls: illegal option -- #{invalid_flag}\n"+
          "usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]"
        end
      end

      def files
        if @dir =~/\./
          @args
        else
          Dir.chdir("#{@dir}") if @dir
          @options[:hidden] ? Dir.entries(".") : Dir.glob("*")
        end
      end

      def directory?
        @args.empty? || (@args.count == 1 && File.directory?(@args.first))
      end

  end
end