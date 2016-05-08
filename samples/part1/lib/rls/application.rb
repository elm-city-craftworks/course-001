module RLs
  class Application
    def initialize(argv)
      options, @paths = parse_options(argv)
      options.merge!(max_byte_count: byte_counts.max)
      @display = RLs::Display.new(options)
    end

    def run
      @paths.each { |p| @display.render(p) }
    end

    private

    def byte_counts
      @paths.flat_map do |p|
        Dir.exist?(p) ? directory_byte_counts(p) : byte_count(p)
      end
    end

    def directory_byte_counts(path)
      directory_subpaths(path).map { |p| byte_count(p) }
    end

    def directory_subpaths(path)
      non_dot_char = /[^\.]/

      Dir.foreach(path)
         .select { |e| e =~ non_dot_char }
         .map    { |e| File.join(path, e) }
    end

    def byte_count(path)
      File.stat(path).size
    end

    def parse_options(argv)
      options = {}
      parser = OptionParser.new do |p|
        p.on('-l') { options[:long_format]    = true }
        p.on('-a') { options[:include_hidden] = true }
      end
      paths = parser.parse(argv)
      paths << Dir.pwd if paths.empty?

      [options, paths]
    end
  end
end
