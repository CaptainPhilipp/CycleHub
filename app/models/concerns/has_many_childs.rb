module HasManyChilds
  extend ActiveSupport::Concern

  included do
    has_many :children_associations, class_name: 'ChildrenParent', as: :parent
    has_many :childs,  through: :children_associations, source_type: 'Category',
                       dependent: :destroy, source: :children
  end

  def add_children(*childrens)
    MultiparentTree::Relation.where(childrens: childrens, parent: self).create
  end

  def remove_children(*childrens)
    MultiparentTree::Relation.where(childrens: childrens, parent: self).destroy
  end

  alias add_childrens add_children
  alias remove_childrens remove_children

  class_methods do
    def where_parents(*parents)
      MultiparentTree::Childrens.where(parents: parents).call
    end

    def where_parent_ids(*parent_ids, type:)
      MultiparentTree::Childrens.where(parent_ids: parent_ids, parents_type: type).call
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
