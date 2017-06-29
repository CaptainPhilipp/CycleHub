module Multiparentable
  extend ActiveSupport::Concern

  included do
    has_many :children_associations, class_name: 'ChildrenParent', as: :parent
    has_many :childs,  through: :children_associations, source_type: 'Category',
                       dependent: :destroy, source: :children

    has_many :parent_associations, class_name: 'ChildrenParent', as: :children
    has_many :parents, through: :parent_associations, source_type: 'Category',
                       dependent: :destroy
  end

  def add_children(*childrens)
    MultiparentTree::Relation.where(childrens: childrens, parent: self).create
  end

  alias add_childrens add_children

  def remove_children(*childrens)
    MultiparentTree::Relation.where(childrens: childrens, parent: self).destroy
  end

  alias remove_childrens remove_children

  def add_parent(*parents)
    MultiparentTree::Relation.where(children: self, parents: parents).create
  end

  alias add_parents add_parent

  def remove_parent(*parents)
    MultiparentTree::Relation.where(children: self, parents: parents).destroy
  end

  alias remove_parents remove_parent

  class_methods do
    def where_parents(*parents)
      MultiparentTree::WhereParentsQuery.new
        .childrens(klass: self).parents(records: parents)
        .call
    end

    def where_parent_ids(*parent_ids, type:)
      MultiparentTree::WhereParentsQuery.new
        .childrens(klass: self).parents(ids: parent_ids, type: type)
        .call
    end
  end

  private

  def increase_children_depth(children:, parent:)
    return true if try_fill_depths children: children, parent: parent
    children.update depth: parent.depth + 1
  end

  def try_fill_depths(children:, parent:) # : Bool
    if children.depth && parent.depth
      parent.depth < children.depth

    elsif children.depth.nil? && children.depth.nil?
      transaction { children.update!(depth: 1) && parent.update!(depth: 0) }

    elsif children.depth.nil?
      children.update(depth: parent.depth + 1)

    elsif parent.depth.nil?
      parent.update(depth: children.depth - 1)
    end
  end
end
