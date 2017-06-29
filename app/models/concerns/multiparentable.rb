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
    childrens.each do |children|
      increase_children_depth(children: children, parent: self)
      create_relation children: children, parent: self
    end
  end

  def remove_children(*childrens)
    childrens.each do |children|
      ChildrenParent.find_by(children: children, parent: self).destroy
    end
  end

  def add_parent(*parents)
    parents.each do |parent|
      decrease_parent_depth(children: self, parent: parent)
      create_relation children: self, parent: parent
    end
  end

  def remove_parent(*parents)
    parents.each do |parent|
      ChildrenParent.find_by(children: self, parent: parent).destroy
    end
  end

  class_methods do
    def where_parents(*parents)
      WhereParentsQuery.new
        .childrens(klass: self)
        .parents(records: parents)
        .execute
    end

    def where_parent_ids(*parent_ids, type:)
      WhereParentsQuery.new
        .childrens(klass: self)
        .parents(ids: parent_ids, type: type)
        .execute
    end
  end

  private

  def create_relation(children:, parent:)
    return true if ChildrenParent.where(children: children, parent: parent).any?
    return false if parent.depth >= children.depth
    ChildrenParent.create children: children, parent: parent
    true
  end

  def decrease_parent_depth(children:, parent:)
    return true if try_fill_depths children: children, parent: parent
    parent.update depth: children.depth - 1
  end

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
