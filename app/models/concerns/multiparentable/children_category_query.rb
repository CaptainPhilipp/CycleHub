module Multiparentable
  class ChildrenCategoryQuery
    def initialize(children: nil, childrens: nil, parent: nil, parents: nil)
      @childrens = childrens || [*children]
      @parents   = parents   || [*parent]
    end

    def create
      ChildrenParent.create(get_collection)
    end

    def destroy
      where_by(get_collection).destroy_all
    end

    private

    attr_reader :childrens, :parents

    def get_collection
      return @collection if @collection
      @collection = []

      parents.each do |parent|
        childrens.each do |children|
          @collection << { parent: parent, children: children }
        end
      end

      @collection
    end

    def where_by(collection)
      collection
        .inject(ChildrenParent.where collection.shift) do |memorized, data|
          memorized.or(ChildrenParent.where data)
        end
    end
  end
end
