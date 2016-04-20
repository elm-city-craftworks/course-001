module RLs
  class Permissions
    def initialize(file_stat)
      @fmode = file_stat.mode
    end

    def to_s
      fm = @fmode

      world = fm % 8
      fm /= 8
      group = fm % 8
      fm /= 8
      owner = fm % 8

      [owner, group, world].map { |bits| read_write_execute(bits) }.join
    end

    private

    def read_write_execute(bits)
      x = (bits % 2) > 0 ? 'x' : '-'
      bits /= 2
      w = (bits % 2) > 0 ? 'w' : '-'
      bits /= 2
      r = (bits % 2) > 0 ? 'r' : '-'

      "#{r}#{w}#{x}"
    end
  end
end
