module Multiparentable
  class TypeObject
    def initialize(type:, klass:)
      @string_type = type  if type.is_a?  String
      @klass       = klass if klass.is_a? Class
      check_arguments
    end

    # Constant
    def klass
      @klass ||= type.constantize
    end

    # Classified
    def type
      @type ||= string.classify || klass.to_s
    end

    # tableized
    def table
      @table ||= string.tableize || type.tableize
    end

    private

    def string
      @string_type
    end

    def check_arguments
      return self if @klass || @string_type
      raise ArgumentError, 'childrens(type: `String`) or childrens(klass: `Class`) must be setted'
    end
  end
end
