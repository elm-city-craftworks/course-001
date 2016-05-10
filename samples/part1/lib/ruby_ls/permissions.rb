module RubyLS
  class Permissions
    ACTORS = [:owner, :group, :other]
    OPERATIONS = [:r, :w, :x]

    def initialize(file_stat)
      @fmode = file_stat.mode
    end

    def to_s
      symbols.join
    end

    private

    def symbols
      bit_masks.map do |mask, operation|
        enabled?(@fmode & mask) ? operation : :-
      end
    end

    def bit_masks
      msb_masks = lsb_masks.reverse
      msb_masks.zip(OPERATIONS.cycle)
    end

    def lsb_masks
      bits = (ACTORS.count * OPERATIONS.count)
      bits.times.map { |offset| 0b1 << offset }
    end

    def enabled?(bits)
      bits > 0
    end
  end
end
