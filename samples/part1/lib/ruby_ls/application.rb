require 'etc'
require 'optparse'
require 'fileutils'

module RubyLs
  class Application
    def initialize(argv)
      parse_options(argv)
    end

    def run
      print_total = false
      if @args.empty?
        @filenames = Dir.entries(".")
        print_total = true
      elsif @args.size == 1 && File.directory?(@args.first)
        FileUtils.cd(@args.first)
        @filenames = Dir.entries(".")
        print_total = true
      else
        @filenames = @args
      end

      unless @all
        @filenames.reject! { |fn| fn.start_with?('.') }
      end

      @file_stats = @filenames.map { |n| stat_file(n) }

      lines = []
      if @long
        lines << "total #{total_blocks}" if print_total
        lines += long_file_lines
      else
        lines = @filenames
      end

      puts lines.join("\n")
    end

    def long_file_lines
      @filenames.zip(@file_stats).map { |filename, stat|
        long_file_line(filename, stat, size_column_width)
      }
    end

    def size_column_width
      @_size_column_width ||= ->{
        max_filesize = @file_stats.map(&:size).max
        min_col_width = 4
        [num_digits(max_filesize) + 2, min_col_width].max
      }.call
    end

    def total_blocks
      @file_stats.map(&:blocks).inject(&:+)
    end

    def long_file_line(filename, stat, size_column_width)
      perms         = permission_string(stat.mode)
      num_links     = stat.nlink
      user          = username(stat.uid)
      group         = groupname(stat.gid)
      size          = stat.size.to_s.rjust(size_column_width)
      last_modified = stat.mtime.strftime("%b %e %H:%M")

      "#{perms}  #{num_links} #{user}  #{group}#{size} #{last_modified} #{filename}"
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

    def num_digits(x)
      x.to_s.size
    end

    def stat_file(filename)
      File.stat(filename)
    rescue Errno::ENOENT
      abort "ls: #{filename}: No such file or directory"
    end

    def parse_options(argv)
      parser = OptionParser.new do |opts|
        opts.on("-l") do |l|
          @long = l
        end

        opts.on("-a") do |a|
          @all = a
        end
      end

      @args = parser.parse(argv)

    rescue OptionParser::InvalidOption => e
      abort [
        "ls: ",
        e.message.gsub(/invalid option: -/, "illegal option -- "),
        "\n",
        "usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]",
        "\n"
      ].join
    end
  end
end
