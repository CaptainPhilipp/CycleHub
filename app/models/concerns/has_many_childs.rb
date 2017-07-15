# frozen_string_literal: true

module HasManyChilds
  extend ActiveSupport::Concern

  included do |klass|
    has_many :children_associations, class_name: 'ChildrenParent', as: :parent
  end

  def add_children(*childrens)
    children_relation.create_for(childrens: childrens)
  end

  def remove_children(*childrens)
    children_relation.remove_for(childrens: childrens)
  end

  alias add_childrens add_children
  alias remove_childrens remove_children

  private

  def children_relation
    @children_relation ||= MultiparentTree::RelationQuery.new(parent: self)
  end
end
