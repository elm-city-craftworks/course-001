module RLs
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

    def initialize(file)
      @file        = file
      @stat        = File.stat(@file)
      @permissions = RLs::Permissions.new(@stat)
    end

    def to_s
      "#{mode} #{links} #{owner}  #{group} #{bytes} #{last_modified} #{path}"
    end

    private

    attr_reader :file, :stat, :permissions

    def mode
      ftype = FTYPES[stat.ftype]
      "#{ftype}#{permissions}"
    end

    def links
      nlink = stat.nlink
      nlink.to_s.rjust(2)
    end

    def owner
      `id -un #{stat.uid}`.chomp
    end

    def group
      `id -gn #{stat.uid}`.chomp
    end

    def bytes
      size = stat.size
      size.to_s.rjust(4)
    end

    def last_modified
      time = stat.mtime
      time.strftime('%b %e %H:%M')
    end

    def path
      file.path
    end
  end
end
