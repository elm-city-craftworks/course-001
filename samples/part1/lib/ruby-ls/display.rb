module RubyLS
  class Display
    attr_reader :display_format, :show_hidden, :glob, :files

    def initialize(params)
      @display_format = params[:display_format]
      @show_hidden    = params[:show_hidden]
      @glob = false
    end
  
    def render(data)
      report = ''

      if data.empty?
        @files = get_directory(Dir.pwd)
      else
        @files = []
        data.each do |dir|
          @files.push(*get_directory(dir))
        end
      end

      glob = @files.none? { |d| File.directory?(d) }

      if display_format
        block_total = 0
        @files.each do |file|
          block_total += File.stat(file).blocks
          report << build_long_report(file)
        end
        puts "total #{block_total}" unless glob
      else
        @files.each do |file|
          report << "#{file}\n"
        end
      end
      puts report
    end

    def get_directory(dir)
      if !File.file?(dir) && !File.directory?(dir)
        $stderr.puts "ls: #{dir}: No such file or directory"
        exit(1)
      end

      if Dir.exists?(dir)
        Dir.chdir(dir)
        files = show_hidden == true ? Dir.entries('.') : Dir.glob('*')
      else
        files = Dir.glob(dir)
      end
    end

    def padding(files)
      files.map { |f| File.stat(f).size.to_s.size }.max 
    end

    def build_long_report(dir)
      output = ''

      uid = File.stat(dir).uid
      gid = File.stat(dir).gid
      mode = get_mode_string(dir)
      links = File.stat(dir).nlink.to_s
      size = File.stat(dir).size.to_s
      mtime = File.stat(dir).mtime
      mtime = mtime.strftime("%b %e %H:%M")
      uname = Etc.getpwuid(uid).name
      gname = Etc.getgrgid(gid).name
      output << mode + '  '
      output << links + ' '
      output << uname + '  '
      output << gname + '  '
      output << size.rjust(padding(files)) + ' '
      output << mtime + ' '
      output << dir
      output << "\n"
    end

    def get_mode_string(file)
      read_idx = [0, 3, 6]
      write_idx = [1, 4, 7]
      exe_idx = [2, 5, 8]
      mode_string = ''

      if Dir.exists?(file)
        mode_string << 'd'
      else
        mode_string << '-'
      end

      mode = File.stat(file).mode
      mode_bits = mode.to_s(2).split(//).last(9)
      mode_bits.each_with_index do |b, i|
        if b == "1"
          if read_idx.include?(i)
            mode_string << 'r'
          elsif write_idx.include?(i)
            mode_string << 'w'
          elsif exe_idx.include?(i)
            mode_string << 'x'
          end
        else
          mode_string <<  '-'
        end
      end
      mode_string
    end
  end
end
