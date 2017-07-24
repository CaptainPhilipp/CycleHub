# frozen_string_literal: true

module MultiparentTree
  class TypeObject
    def initialize(type: nil, klass: nil)
      @string_type = type
      @constant_class = klass
    end

    # Symbol or tableized
    def table
      @table ||= klass.try(:table_name)
    end

    # Constant
    def klass
      @klass ||= @constant_class || type.try(:constantize)
    end

    # classified
    def type
      @type ||= @string_type || @constant_class.try(:to_s)
    end
  end
end
