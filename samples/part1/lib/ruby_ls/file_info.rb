module RubyLs
  class FileInfo
  	
    attr_reader :data
    MODES = { "0" => "---", "1" => "--x", "2" => "-w-", "3" => "-wx",
              "4" => "r--", "5" => "r-x", "6" => "rw-", "7" => "rwx" }

  	attr_reader :file
  	        
  	def initialize(file)
  	  @file = file
  	end

  	def details
  	  file_info
  	end

    def keys
      @data.keys
    end

  	private

    def file_info
      stats = File::Stat.new(file)
      @data = {
        permissions: permission_string(stats.mode),
        link_count: stats.nlink,
        owner: Etc.getpwuid(stats.uid).name,
        group: Etc.getgrgid(stats.gid).name,
        size: File.size(file),
        time: stats.mtime.strftime("%b %e %H:%M"),
        name: file,
        blocks: stats.blocks
      }
    end

    def permission_string(mode)
      dir_flag  = mode[15] == 0 ? "d" : "-"
      ugw_codes = (mode & 0777).to_s(8).chars
      dir_flag + ugw_codes.map { |n| MODES[n] }.join
    end
  end
end