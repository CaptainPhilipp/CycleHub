module MultiparentTree
  class Relation
    def initialize(children: nil, childrens: nil, parent: nil, parents: nil)
      @childrens = childrens || [children]
      @parents   = parents   || [parent]
    end

    def self.where(**args)
      new(args)
    end

    def create
      ChildrenParent.create(get_params_variants)
    end

    def destroy
      where_or(get_params_variants).destroy_all
    end

    private

    attr_reader :childrens, :parents

    def get_params_variants
      return @params if @params
      @params = []

      parents.each do |parent|
        childrens.each do |children|
          @params << { parent: parent, children: children }
        end
      end

      @params
    end

    def where_or(collection)
      collection
        .inject(ChildrenParent.where collection.shift) do |memorized, data|
          memorized.or(ChildrenParent.where data)
        end
    end
  end
end
