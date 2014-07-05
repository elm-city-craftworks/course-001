module RubyLs
  class Application

  	def initialize(argv)
      @params, @args = parse_options(argv)
      @dir = @args.first
      @display = RubyLs::Display.new(@params)
  	end

  	def run
  	  if @dir =~ /\./
        @display.render(@args)        
  	  elsif @dir
  	  	Dir.chdir("#{@dir}")
  	  	@display.render(files)
  	  else
  	  	@display.render(files)
  	  end
  	end

    private

      def parse_options(argv)
        params = {}
        parser = OptionParser.new
        parser.on("-l") {params[:detail] = true}
        parser.on("-a") {params[:hidden] = true}
        dir = parser.parse(argv)
        [params, dir]
      end

      def files
        @params[:hidden] ? Dir.entries(".") : Dir.glob("*")
      end

  end
end