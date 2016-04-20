module RLs
  class Application
    def initialize(argv)
      @options, @paths = parse_options(argv)
      @display = RLs::Display.new(@options)
    end

    def run
      paths.any? ? list_paths : list_current_directory
    end

    private

    attr_reader :paths, :display

    def parse_options(argv)
      options = {}
      parser = OptionParser.new do |p|
        p.on('-l') { options[:long_format]    = true }
        p.on('-a') { options[:include_hidden] = true }
      end
      paths = parser.parse(argv)

      [options, paths]
    end

    def list_current_directory
      display.render(Dir.pwd)
    end

    def list_paths
      paths.each { |path| display.render(path) }
    end
  end
end
