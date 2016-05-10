module RubyLS
  class Display
    def initialize(options)
      @long_format    = options[:long_format]
      @include_hidden = options[:include_hidden]
      @max_byte_count = options[:max_byte_count]
    end

    def render(path)
      if Dir.exist?(path)
        render_directory(path)
      else
        render_file(path)
      end
    end

    private

    def render_directory(dirname)
      list_total_blocks(dirname) if @long_format
      Dir.foreach(dirname) { |e| render_file(e) }
    end

    def list_total_blocks(dirname)
      puts "total #{total_blocks(dirname)}"
    end

    def total_blocks(dirname)
      entries(dirname).reduce(0) do |sum, e|
        path = File.join(dirname, e)
        sum + blocks_allocated(path)
      end
    end

    def entries(dirname)
      Dir.entries(dirname).select { |e| show?(e) }
    end

    def blocks_allocated(path)
      File.stat(path).blocks
    end

    def render_file(filename)
      if show?(filename)
        puts formatted(filename)
      end
    end

    def show?(filename)
      @include_hidden || !hidden?(filename)
    end

    def hidden?(filename)
      filename[0] == '.'
    end

    def formatted(filename)
      if @long_format
        File.open(filename) { |f| RubyLS::FileDetails.new(f, @max_byte_count) }
      else
        filename
      end
    end
  end
end
