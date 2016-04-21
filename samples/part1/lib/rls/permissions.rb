module RLs
  class Permissions
    COMPONENTS = [:owner, :group, :world]
    OPERATIONS = [:r, :w, :x]
    DASH = '-'.freeze

    def initialize(file_stat)
      @fmode = file_stat.mode
    end

    def to_s
      rwx = component_fields.map do |field|
        permitted_operations(field)
      end
      rwx.join
    end

    private

    def component_fields
      max_component_index = COMPONENTS.count - 1
      bits_per_component = OPERATIONS.count
      operation_combos = 2 ** bits_per_component

      COMPONENTS.each_with_index.map do |component, i|
        lesser_components = max_component_index - i
        bit_offset = lesser_components * bits_per_component

        (@fmode >> bit_offset) % operation_combos
      end
    end

    def permitted_operations(field)
      max_operation_index = OPERATIONS.count - 1
      bits_per_operation = 1
      cardinality = 2 ** bits_per_operation

      bits = OPERATIONS.each_with_index.map do |symbol, index|
        lesser_operations = max_operation_index - index
        bit_offset = lesser_operations * bits_per_operation

        bit = (field >> bit_offset) % cardinality
        bit > 0 ? symbol : DASH
      end

      bits.join
    end
  end
end
