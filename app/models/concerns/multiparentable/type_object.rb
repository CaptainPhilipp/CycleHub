module Multiparentable
  class TypeObject
    def initialize(type: nil, klass: nil, table: nil)
      @string_type    = type.is_a?(String) ? type  : nil
      @string_table   = type.is_a?(String) ? table : nil
      @symbol_table   = type.is_a?(Symbol) ? table : nil
      @constant_class = klass.is_a?(Class) ? klass : nil
      check_arguments
    end

    # Constant
    def klass
      @klass ||= @constant_class || type.constantize
    end

    # Symbol or tableized
    def table
      @table ||= @symbol_table || @string_table || klass.table_name
    end

    # classified
    def type
      @type ||= @string_type || @constant_class.try(:to_s) || table_to_s.try(:classify)
    end

    private

    def table_to_s
      @string_table || (@symbol_table && @symbol_table.to_s)
    end

    def check_arguments
      return self if @constant_class || @string_type || @string_table || @symbol_table
      raise ArgumentError, "(type: 'Classified'), (klass: Constant) or (table: 'tableized') must be setted"
    end
  end
end
