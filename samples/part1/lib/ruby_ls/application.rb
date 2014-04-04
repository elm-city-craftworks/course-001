module RubyLs
  class Application
    def initialize(argv)
    end

    def run
      Dir.entries(".").reject { |name| name.start_with?('.') }.each do |name|
        puts name
      end
    end
  end
end
