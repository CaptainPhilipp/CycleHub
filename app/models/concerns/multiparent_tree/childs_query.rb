# frozen_string_literal: true

module MultiparentTree
  class ChildsQuery
    def initialize(type: nil, klass: nil)
      @childs_object = TypeObject.new(type: type, klass: klass)
    end

    def where(parents: nil, type: nil, klass: nil, ids: nil)
      @parents_object = CollectionObject.new parents, type: type, klass: klass, ids: ids
      return [] unless parents&.any? || ids&.any?

      query_strategy.call
    end

    private

    def query_strategy
      chosen_strategy.new(childs_object: @childs_object, parents_object: @parents_object)
    end

    def chosen_strategy
      @parents_object.count > 1 ? Query::Multiparent : Query::Singleparent
    end
  end
end
