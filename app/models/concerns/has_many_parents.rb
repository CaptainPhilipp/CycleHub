# frozen_string_literal: true

module HasManyParents
  extend ActiveSupport::Concern

  included do |klass|
    has_many :parent_associations, class_name: 'ChildrenParent', as: :children
    has_many :parents, through: :parent_associations, source_type: klass.to_s,
                       dependent: :destroy
  end

  def add_parent(*parents)
    parent_relation.create_for(parents: parents)
  end

  def remove_parent(*parents)
    parent_relation.remove_for(parents: parents)
  end

  alias add_parents add_parent
  alias remove_parents remove_parent

  class_methods do
    def where_parents(*parents)
      childs_query.where(parents: parents)
    end

    def where_parent_ids(*parent_ids, type:)
      childs_query.where(parent_ids: parent_ids, parents_type: type)
    end

    private

    def childs_query
      MultiparentTree::ChildsQuery.new(klass: self)
    end
  end

  private

  def parent_relation
    @parent_relation ||= MultiparentTree::RelationQuery.new(children: self)
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
