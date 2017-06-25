module Multiparentable
  class QueryGenerator
    JOIN_TABLE = 'children_parents'

    def childrens(type: nil, klass: nil)
      @children = TypeObject.new(type: type, klass: klass)
      self
    end

    def parents(records: [], type: nil, ids: )
      if records.any? && records.all? { |r| r.is_a? ActiveRecord }
        @parents = records
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

    attr_reader :parents, :parent_ids, :parents_type, :children

    def parents_count
      if parents.any?
        parents.size
      else parent_ids
        parent_ids.size
      end
    end

    def multiparent_query
      single_parent_query
        .group("#{children.table}.id")
        .having("count(#{JOIN_TABLE}.parent_id) = ?", parent_ids.size)
    end

    def single_parent_query
      children.klass
        .joins(inner_join_query_part)
        .where(JOIN_TABLE => { parent_id:     parent_ids,
                               parent_type:   parents_type.to_s,
                               children_type: children_type })
    end

    def inner_join_query_part
      "INNER JOIN #{JOIN_TABLE}" +
      "ON #{children.table}.id = #{JOIN_TABLE}.children_id"
    end

    def raise_parents_arguments
      raise ArgumentError, 'parents(records:``) or parents(ids: ``, type: ``) must be setted'
    end
  end
end
