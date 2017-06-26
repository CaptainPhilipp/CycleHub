module Multiparentable
  class TypeObject
    def initialize(type: nil, klass: nil, table: nil)
      @string_type    = type  if type.is_a?  String
      @string_table   = table if type.is_a?  String
      @symbol_table   = table if type.is_a?  Symbol
      @constant_class = klass if klass.is_a? Class
      check_arguments
    end

    # Constant
    def klass
      @klass ||= @constant_class || type.constantize
    end
    
    # Symbol or tableized
    def table
      @any_table ||= @symbol_table || table_str
    end
    
    # classified
    def type
      @type ||= @string_type || @string_table.classify || @constant_class.to_s
    end
    
    # Symbol
    def table_sym
      @table_sym ||= @symbol_table || table_str.to_sym
    end
    
    # tableized
    def table_str
      @table ||= @string_table || any_string.tableize
    end

    private
    
    def any_string
      @string ||= string_table || string_type || constant_class.to_s || @symbol_table.to_s
    end

    def check_arguments
      return self if @klass || @string_type
      raise ArgumentError, "(type: 'Classified'), (klass: Constant) or (table: 'tableized') must be setted"
    end
  end
end
