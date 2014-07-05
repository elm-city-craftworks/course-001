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
  	  	@display.render(Dir.glob("*"))
  	  else
  	  	@display.render(Dir.glob("*"))
  	  end
  	end

    private

      def parse_options(argv)
        params = {}
        parser = OptionParser.new
        parser.on("-l") {params[:detail] = true}
        dir = parser.parse(argv)
        [params, dir]
      end

  end
end