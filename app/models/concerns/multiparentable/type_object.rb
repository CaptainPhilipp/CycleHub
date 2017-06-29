module Multiparentable
  class TypeObject
    def initialize(type: nil, klass: nil)
      @string_type    = type.is_a?(String) ? type  : nil
      @constant_class = klass.is_a?(Class) ? klass : nil
      check_arguments!
    end

    # Symbol or tableized
    def table
      @table ||= klass.table_name
    end

    # Constant
    def klass
      @klass ||= @constant_class || type.constantize
    end

    # classified
    def type
      @type ||= @string_type || @constant_class.try(:to_s)
    end

    private

    def check_arguments!
      return self if @constant_class || @string_type
      raise ArgumentError, "(type: 'Classified'), (klass: Constant) or (table: 'tableized') must be setted"
    end
  end
end
