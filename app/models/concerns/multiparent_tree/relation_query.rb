# frozen_string_literal: true

module MultiparentTree
  class RelationQuery
    def initialize(**args)
      assign_attributes(args)
    end

    def create_for(**args)
      assign_attributes(args)
      ChildrenParent.create(get_params_variants)
    end

    def remove_for(**args)
      assign_attributes(args)
      where_or(get_params_variants).destroy_all
    end

    private

    attr_reader :childrens, :parents

    def assign_attributes(children: nil, childrens: nil, parent: nil, parents: nil)
      @childrens ||= childrens || children && [children]
      @parents   ||= parents   || parent   && [parent]
    end

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
        .inject(ChildrenParent.where(collection.shift)) do |memorized, data|
          memorized.or(ChildrenParent.where(data))
        end
    end
  end
end
