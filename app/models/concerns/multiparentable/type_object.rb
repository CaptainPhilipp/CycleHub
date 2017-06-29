module Multiparentable
  class TypeObject
    def initialize(type: nil, klass: nil)
      assign_type(klass || type)
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

    private

    def assign_type(type)
      case type
      when String then @string_type = type
      when Class  then @constant_class = type
      end
    end
  end
end
