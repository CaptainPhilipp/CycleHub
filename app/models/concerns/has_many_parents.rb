# frozen_string_literal: true

module HasManyParents
  extend ActiveSupport::Concern

  included do |klass|
    has_many :parent_associations, class_name: 'ChildrenParent', as: :children
    has_many "parent_#{klass.to_s.tableize}".to_sym,
             through: :parent_associations, source_type: klass.to_s,
             dependent: :destroy, source: :parent

    scope :close_relative, -> { where(children_parents: { close_relative: true }) }
  end

  def add_parent(*parents)
    parent_relation.create_for(parents: parents)
  end

  def remove_parent(*parents)
    parent_relation.remove_for(parents: parents)
  end

  alias add_parents add_parent
  alias remove_parents remove_parent

  private

  def parent_relation
    @parent_relation ||= MultiparentTree::RelationQuery.new(children: self)
  end

  class_methods do
    def where_parents(*parents)
      query_childs.where(parents: parents)
    end

    def where_parent_ids(*parent_ids, klass:)
      query_childs.where(ids: parent_ids.flatten, klass: klass)
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def query_childs
      MultiparentTree::ChildsQuery.new(klass: self)
    end
  end
end
