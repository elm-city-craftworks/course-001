require 'etc'
require 'optparse'

module RubyLs
  class Application
    def initialize(argv)
      parser = OptionParser.new do |opts|
        opts.on("-l") do |l|
          @long = l
        end

        opts.on("-a") do |a|
          @all = a
        end
      end

      @files = parser.parse(argv)
      if @files.empty?
        @dir = true
        @files = Dir.entries(".")
      end

      @blocks = 0
      @lines = []
    rescue OptionParser::InvalidOption => e
      abort [
        "ls: ",
        e.message.gsub(/invalid option: -/, "illegal option -- "),
        "\n",
        "usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]",
        "\n"
      ].join
    end

    def run
      lines = []

      max_filesize = @files.map { |fn| stat_file(fn).size }.max
      size_width = [int_width(max_filesize) + 1, 4].max

      @files.each do |filename|
        next if !@all && filename.start_with?('.')

        stat = stat_file(filename)

        if @long
          perms         = permission_string(stat.mode)
          num_links     = stat.nlink
          user          = username(stat.uid)
          group         = groupname(stat.gid)
          size          = stat.size.to_s.rjust(size_width)
          last_modified = stat.mtime.strftime("%b %e %H:%M")

          line = "#{perms}  #{num_links} #{user}  #{group}#{size} #{last_modified} #{filename}"
        else
          line = filename
        end

        add_line(line)

        count_blocks(stat.blocks)
      end

      print_total if @long && @dir

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
      # The explicit way:
      # =================

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

      masks_to_symbols.to_a.map { |mask, symbol| mode & mask > 0 ? symbol : "-" }.join

      # Or the esoteric way:
      # ====================

      # file_type = (mode & 040000 > 0) ? "d" : "-"
      # symbols = "rwx" * 3
      # permissions = 8.downto(0).map { |i| mode[i] == 1 ? symbols[8-i] : "-" }.join
      # file_type + permissions
    end

    def username(uid)
      Etc.getpwuid(uid).name
    end

    def groupname(gid)
      Etc.getgrgid(gid).name
    end

    def int_width(x)
      Math.log10(x).ceil + 1
    end

    def stat_file(filename)
      File.stat(filename)
    rescue Errno::ENOENT
      abort "ls: #{filename}: No such file or directory"
    end
  end
end
