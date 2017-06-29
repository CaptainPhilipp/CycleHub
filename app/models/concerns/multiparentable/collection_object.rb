module Multiparentable
  class CollectionObject
    def initialize(records: nil, ids: nil, type: nil, klass: nil)
      @type_object = TypeObject.new(type: type || klass)
      @ids = ids
      @records = [*records]
    end

    def ids
      @ids ||= klass ? by_class[klass] : false
    end

    def type
      @type ||= type_object.type || get_class_from_records.try(:to_s)
    end

    def klass
      @klass ||= type_object.klass || get_class_from_records
    end

    def records
      @records
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

    def get_class_from_records
      @class_from_collection ||=
        by_class.size == 1 ? by_class.keys.first : false
    end

    attr_reader :type_object
  end
end
