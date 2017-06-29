module HasManyParents
  extend ActiveSupport::Concern

  included do
    has_many :parent_associations, class_name: 'ChildrenParent', as: :children
    has_many :parents, through: :parent_associations, source_type: 'Category',
                       dependent: :destroy
  end

  def add_parent(*parents)
    MultiparentTree::Relation.where(children: self, parents: parents).create
  end

  def remove_parent(*parents)
    MultiparentTree::Relation.where(children: self, parents: parents).destroy
  end

  alias add_parents add_parent
  alias remove_parents remove_parent

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
