require 'etc'
require 'optparse'

module RubyLs
  class Application
    def initialize(argv)
      parser = OptionParser.new do |opts|
        opts.on("-l") do |l|
          @long = l
        end
      end

      @pattern = parser.parse(argv)
      @pattern = "*" if @pattern.empty?

      @blocks = 0
      @lines = []
    end

    def run
      lines = []
      Dir.glob(@pattern).reject { |name| name.start_with?('.') }.each do |filename|
        stat = File.stat(filename)

        if @long
          perms         = permission_string(stat.mode)
          num_links     = stat.nlink
          user          = username(stat.uid)
          group         = groupname(stat.gid)
          size          = stat.size.to_s.rjust(5) # XXX: Will fail when file size grows
          last_modified = stat.mtime.strftime("%b %e %H:%M")

          line = "#{perms}  #{num_links} #{user}  #{group}#{size} #{last_modified} #{filename}"
        else
          line = filename
        end

        add_line(line)

        count_blocks(stat.blocks)
      end

      print_total if @long
      print_entries
    end

    def print_total
      puts "total #{@blocks}"
    end

    def print_entries
      puts @lines.join("\n")
    end

    def add_line(line)
      @lines << line
    end

    def count_blocks(blocks)
      @blocks += blocks
    end

    def permission_string(mode)
      # See chmod(2) and stat(2)
      masks_to_symbols = {
        040000 => "d",
          0400 => "r",
          0200 => "w",
          0100 => "x",
           040 => "r",
           020 => "w",
           010 => "x",
            04 => "r",
            02 => "w",
            01 => "x"
      }

      masks_to_symbols.to_a.map { |mask, symbol|
        mode & mask > 0 ? symbol : "-"
      }.join
    end

    def username(uid)
      Etc.getpwuid(uid).name
    end

    def groupname(gid)
      Etc.getgrgid(gid).name
    end
  end
end
