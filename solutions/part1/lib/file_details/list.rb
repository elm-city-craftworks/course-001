class FileDetails
  class List
    def initialize(files)
      @details       = []
      @column_widths = Hash.new(0)
      
      files.each do |f|
        fd = FileDetails.new(f)

        fd.keys.each do |k|
          @column_widths[k] = [@column_widths[k], fd[k].to_s.size].max
        end

        @details << fd
      end
    end

    attr_reader :column_widths

    def each
      @details.each { |e| yield(e) }
    end
  end
end
