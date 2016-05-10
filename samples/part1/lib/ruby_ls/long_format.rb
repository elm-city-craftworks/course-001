module RubyLS
  class LongFormat
    FTYPES = {
      'blockSpecial'     => 'b',
      'characterSpecial' => 'c',
      'directory'        => 'd',
      'link'             => 'l',
      'socket'           => 's',
      'fifo'             => 'P',
      'file'             => '-'
    }

    def initialize(file, max_byte_count)
      @file = file
      @stat = File.stat(@file)
      @permissions = RubyLS::Permissions.new(@stat)
      @max_byte_count = max_byte_count
    end

    def to_s
      "#{mode} #{links} #{owner}  #{group} #{bytes} #{last_modified} #{path}"
    end

    private

    def mode
      ftype = FTYPES[@stat.ftype]
      "#{ftype}#{@permissions}"
    end

    def links
      nlink = @stat.nlink
      nlink.to_s.rjust(2)
    end

    def owner
      `id -un #{@stat.uid}`.chomp
    end

    def group
      `id -gn #{@stat.uid}`.chomp
    end

    def bytes
      size = @stat.size
      col_width = @max_byte_count.to_s.length + 1
      size.to_s.rjust(col_width)
    end

    def last_modified
      time = @stat.mtime
      time.strftime('%b %e %H:%M')
    end

    def path
      @file.path
    end
  end
end
