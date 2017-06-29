module Multiparentable
  class ChildrenCategoryQuery
    def initialize(children: nil, childrens: nil, parent: nil, parents: nil)
      @childrens = childrens || [*children]
      @parents   = parents   || [*parent]
    end

    def create
      ChildrenParent.create(collection)
    end

    def destroy
      where_by_collection.destroy_all
    end

    private

    attr_reader :childrens, :parents

    def where_by_collection
      collection
        .inject(ChildrenParent.where collection.shift) do |memorized, data|
          memorized.or(ChildrenParent.where data)
        end
    end

    def collection
      return @collection if @collection
      @collection = []
      parents.each do |parent|
        childrens.each do |children|
          @collection << { parent: parent, children: children }
        end
      end
      @collection
    end
  end
end
