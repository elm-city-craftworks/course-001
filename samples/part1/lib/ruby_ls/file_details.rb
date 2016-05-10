require 'etc'

module RubyLS
  class FileDetails
    FTYPES = {
      'blockSpecial'     => 'b',
      'characterSpecial' => 'c',
      'directory'        => 'd',
      'link'             => 'l',
      'socket'           => 's',
      'fifo'             => 'P',
      'file'             => '-'
    }

    def initialize(file, max_byte_count = nil)
      @file = file
      @stat = File.stat(@file)
      @permissions = RubyLS::Permissions.new(@stat)
      @max_byte_count = max_byte_count
    end

    def to_s
      "#{mode} #{links.to_s.rjust(2)} #{owner}  #{group} #{bytes} #{mtime} #{path}"
    end

    def [](key)
      send(key)
    end

    private

    attr_reader :permissions

    def mode
      ftype = FTYPES[@stat.ftype]
      "#{ftype}#{permissions}"
    end

    def links
      @stat.nlink
    end

    def owner
      Etc.getpwuid(@stat.uid).name
    end

    def group
      Etc.getgrgid(@stat.gid).name
    end

    def bytes
      col_width = (@max_byte_count || size).to_s.length + 1
      size.to_s.rjust(col_width)
    end

    def size
      @stat.size
    end

    def mtime
      time = @stat.mtime
      time.strftime('%b %e %H:%M')
    end

    def path
      @file.path
    end
  end
end
