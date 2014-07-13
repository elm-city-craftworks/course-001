require 'etc'
module RubyLs
  class Display

    def initialize(params)
  	  @details = params[:detail]
      @hidden = params[:hidden]
      @column_widths = Hash.new(0)
      @total_blocks = 0
  	end

  	def render(data, directory=false)
  	  if @details
  	  	details = get_details(data)
        output, total_blocks = build_details_output(details)
        print_total_blocks if directory
        print_output(details)
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

    def print_output(details)
      details.each do |d|
        output = [d[:permissions],
                  d[:link_count].to_s.rjust(@column_widths[:link_count] + 1, " "),
                  d[:owner] + " ",
                  d[:group],
                  d[:size].to_s.rjust(@column_widths[:size] + 1, " "),
                  d[:time], 
                  d[:name]]
        puts output.join(" ")
      end
    end

    def build_details_output(details, total_blocks=0)
      @output = details.each do |d|
        d.keys.each do |k|
          @column_widths[k] = [@column_widths[k], d[k].to_s.size].max
        end
        total_blocks += d[:blocks]
      end
      @total_blocks = total_blocks
    end

 end
end