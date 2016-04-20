module RLs
  class Display
    def initialize(options)
      @long_format = options[:long_format]
    end

    def render(path)
      if Dir.exist?(path)
        render_directory(path)
      else
        list_if_visible(path)
      end
    end

    private

    attr_reader :long_format

    def render_directory(dirname)
      list_total_blocks(dirname) if long_format
      Dir.foreach(dirname) { |e| list_if_visible(e) }
    end

    def list_total_blocks(dirname)
      puts "total #{total_blocks(dirname)}"
    end

    def total_blocks(dirname)
      entries = Dir.entries(dirname).reject { |e| hidden?(e) }

      entries.reduce(0) do |sum, e|
        path = File.join(dirname, e)
        sum + blocks_allocated(path)
      end
    end

    def blocks_allocated(path)
      File.stat(path).blocks
    end

    def list_if_visible(filename)
      list(filename) if ! hidden?(filename)
    end

    def hidden?(filename)
      filename[0] == '.'
    end

    def list(filename)
      puts formatted(filename)
    end

    def formatted(filename)
      if long_format
        File.open(filename) { |f| RLs::LongFormat.new(f) }
      else
        filename
      end
    end
  end
end
