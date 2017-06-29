module Multiparentable
  class Query
    def childrens(type: nil, klass: nil)
      @children = TypeObject.new(type: type, klass: klass)
      self
    end

    def parents(records: [], type: nil, ids: nil)
      if records.any?
        @parents_collection = records
        @parent_ids   = @parents_collection.map(&:id)
        @parents_type = @parents_collection.first.class
      elsif type && ids
        @parent_ids = ids
        @parents_type = type
      else
        raise_parents_arguments
      end

      self
    end

    def execute
      parents_count > 1 ? multiparent_query : single_parent_query
    end

    private

    attr_reader :parents_collection, :parent_ids, :parents_type, :children

    def parents_count
      if parents_collection.any?
        parents_collection.size
      else parent_ids
        parent_ids.size
      end
    end

    def single_parent_query
      children.klass
        .joins(:parent_associations)
        .where(children_parents: { parent_id:     parent_ids,
                                   parent_type:   parents_type.to_s,
                                   children_type: children.type })
    end

    def multiparent_query
      single_parent_query
        .group("#{children.table}.id")
        .having("count(children_parents.parent_id) = ?", parent_ids.size)
    end

    def raise_parents_arguments
      raise ArgumentError,
        'parents(records:``) or parents(ids: ``, type: ``) must be setted' +
        "(parent_ids: #{@parent_ids}, parents_type: #{@parents_type}," \
        "records: #{@parents_collection})"
    end
  end
end
