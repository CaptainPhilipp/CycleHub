# frozen_string_literal: true

module MultiparentTree
  class ChildsQuery
    def initialize(type: nil, klass: nil)
      @childs_object = TypeObject.new(type: type, klass: klass) if type || klass
    end

    def where(parents: nil, parents_type: nil, parent_ids: nil)
      @parents_object = CollectionObject.new  records: parents,
                                              type:    parents_type,
                                              ids:     parent_ids
      parents_object.count > 1 ? multiparent_query : singleparent_query
    end

    private

    attr_reader :parents_object

    def childs_object
      @childs_object ||= TypeObject.new(type: parents_object.type, klass: parents_object.klass)
    end

    def singleparent_query
      begin_query_with(parent_id:     parents_object.ids,
                       parent_type:   parents_object.type,
                       children_type: childs_object.type)
    end

    def multiparent_query
      params_conditions
        .inject begin_query_with(params_conditions.shift) do |memorized, data|
          memorized.or(ChildrenParent.where(data))
        end
        .group(:id)
        .having('count(children_parents.parent_id) = ?', parents_object.count)
    end

    def begin_query_with(conditions)
      childs_object.klass
                   .joins(:parent_associations)
                   .where(children_parents: conditions)
    end

    def params_conditions
      @params_conditions ||=
        parents_object.ids_by_class.to_a.inject [] do |memo, class__ids|
          memo << { parent_type: class__ids.first.to_s,
                    parent_id:   class__ids.last,
                    children_type: childs_object.type }
        end
    end
  end
end
