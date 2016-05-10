module RLs
  class Application
    def initialize(options, paths)
      @options = options
      @paths   = paths
      @display = RLs::Display.new(display_options)
    end

    def run
      @paths.each { |p| @display.render(p) }
    end

    private

    def display_options
      @options.merge(max_byte_count: byte_counts.max)
    end

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
    rescue Errno::ENOENT => e
      raise(e, "#{path}: No such file or directory")
    end
  end
end
