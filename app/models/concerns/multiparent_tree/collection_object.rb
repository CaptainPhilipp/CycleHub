# frozen_string_literal: true

module MultiparentTree
  class CollectionObject
    attr_reader :records

    def initialize(records = nil, ids: nil, type: nil, klass: nil)
      @type_object = TypeObject.new(type: type, klass: klass)
      @ids = ids
      @records = [*records]
    end

    def ids
      raise 'HasManyClasses' unless klass
      @ids ||= records.map(&:id)
    end

    def type
      @type ||= type_object.type || class_from_records.try(:to_s)
    end

    def klass
      @klass ||= type_object.klass || class_from_records
    end

    def count
      @records.try(:size)
    end

    def ids_by_class
      @ids_by_class ||= by_class.transform_values { |records| records.map(&:id) }
    end

    def by_class
      @by_class ||= records.group_by(&:class)
    end

    private

    attr_reader :type_object

    def class_from_records
      @class_from_collection ||= by_class.size > 1 ? nil : records.first.class
    end
  end
end
