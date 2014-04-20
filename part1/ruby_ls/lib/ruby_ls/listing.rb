module RubyLS
  class Listing
    def initialize(file_details)
      @details       = []
      @column_widths = Hash.new(0)
      @blocks        = 0
      
      file_details.each do |fd|
        fd.keys.each do |k|
          @column_widths[k] = [@column_widths[k], fd[k].to_s.size].max
        end

        @blocks += fd[:blocks]

        @details << fd
      end
    end

    attr_reader :column_widths, :blocks

    def each
      @details.each { |e| yield(e) }
    end
  end
end
