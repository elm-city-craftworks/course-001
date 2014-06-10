module RubyLs
  class Application

  	def initialize(argv)
  	  @dir = argv.first
  	  @stuff = argv
  	end

  	def run
  	  if @dir =~ /\./
  	  	puts Dir.glob("#{@dir}")
  	  elsif @dir
  	  	Dir.chdir("#{@dir}")
  	  	puts Dir.glob("*")
  	  else
  	  	puts Dir.glob("*")
  	  end
  	end

  end
end