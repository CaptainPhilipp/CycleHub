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

    def call
      parents_object.count > 1 ? multiparent_query : singleparent_query
    end

    private

    attr_reader :parents_object, :childrens_object, :params

    def begin_query
      childrens_object.klass
        .joins(:parent_associations)
    end

    def singleparent_query
      begin_query
        .where(children_parents: { parent_id:     parents_object.ids,
                                   parent_type:   parents_object.type,
                                   children_type: childrens_object.type })
    end

    def start_inject_query
      begin_query.where(children_parents: get_params.shift)
    end

    def multitype_query
      get_params
        .inject(start_inject_query) do |memorized, data|
          memorized.or(ChildrenParent.where data)
        end
    end

    def multiparent_query
      multitype_query
        .group(:id)
        .having("count(children_parents.parent_id) = ?", parents_object.count)
    end

    def get_params
      return @params if @params
      @params = []

      parents_object.ids_by_class.each do |klass, ids|
        params << { parent_type: klass.to_s,
                    parent_id: ids,
                    children_type: childrens_object.type }
      end

      params
    end

    alias params get_params
  end
end
