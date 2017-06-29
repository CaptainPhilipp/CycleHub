module Multiparentable
  class WhereParentsQuery
    def childrens(type: nil, klass: nil)
      @childrens_object = TypeObject.new(type: type, klass: klass)
      self
    end

    def parents(records: nil, type: nil, ids: nil)
      @parents_object = CollectionObject.new(records: records, type: type, ids: ids)
      self
    end

    def execute
      parents_object.count > 1 ? multiparent_query : single_parent_query
    end

    private

    attr_reader :parents_object, :childrens_object

    def single_parent_query
      childrens_object.klass
        .joins(:parent_associations)
        .where(children_parents: { parent_id:     parents_object.ids,
                                   parent_type:   parents_object.type,
                                   children_type: childrens_object.type })
    end

    def multiparent_query
      single_parent_query
        .group("#{childrens_object.table}.id")
        .having("count(children_parents.parent_id) = ?", parents_object.count)
    end
  end
end
