require 'etc'
module RubyLs
  class Display

    def initialize(params)
  	  @details = params[:detail]
  	end

  	def render(data)
  	  if @details
  	  	details = get_details(data)
        output, total_blocks = build_details_output(details)
        print_total_blocks
        print_output
  	  else
  	  	puts data
  	  end
  	end

  	private

  	def get_details(data)
  	  data.inject([]) do |info, file|
        info << FileInfo.new(file).details
        info
      end
  	end

    def print_total_blocks
      puts "total #{@total_blocks}"
    end 

    def print_output
      puts @output
    end

    def build_details_output(details, total_blocks=0)
      @output = details.inject([]) do |output, d|
        output << "#{d[:permissions]}  #{d[:link_count]} #{d[:owner]}  #{d[:group]} #{d[:size].to_s.rjust(4)} #{d[:time]} #{d[:name]}"
        total_blocks += d[:blocks]
        output
      end
      @total_blocks = total_blocks
    end

 end
end