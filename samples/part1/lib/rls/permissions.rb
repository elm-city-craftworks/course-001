module RLs
  class Permissions
    FIELDS = [:owner, :group, :world]
    OPERATIONS = [:r, :w, :x]
    MINUS = '-'.freeze

    def initialize(file_stat)
      @fmode = file_stat.mode
    end

    def to_s
      rwx = field_components.map do |bit_field|
        permitted_operations(bit_field) do |bit, operation|
          enabled?(bit) ? operation : MINUS
        end
      end

      rwx.join
    end

    private

    def field_components
      mode_components(@fmode, FIELDS, bits_per_component: OPERATIONS.count)
    end

    def permitted_operations(bit_field, &block)
      mode_components(bit_field, OPERATIONS, bits_per_component: 1, &block)
    end

    def mode_components(mode, components, bits_per_component:)
      max_index = components.count - 1
      cardinality = 2 ** bits_per_component

      components.each_with_index.map do |component, index|
        lesser_components = max_index - index
        bit_offset = lesser_components * bits_per_component

        val = (mode >> bit_offset) % cardinality
        val = yield(val, component) if block_given?
        val
      end
    end

    def enabled?(bit)
      bit > 0
    end
  end
end
