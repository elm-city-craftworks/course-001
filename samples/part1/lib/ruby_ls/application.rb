module RubyLs
  class Application
    def initialize(argv)
      @pattern = argv.empty? ? "*" : argv
    end

    def run
      Dir.glob(@pattern).reject { |name| name.start_with?('.') }.each do |name|
        puts name
      end
    end
  end
end
