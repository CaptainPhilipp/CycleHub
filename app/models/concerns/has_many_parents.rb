# frozen_string_literal: true

module HasManyParents
  extend ActiveSupport::Concern

  included do |klass|
    has_many :parent_associations, class_name: 'ChildrenParent', as: :children
    has_many "#{klass.to_s.downcase}_parents".to_sym,
             through: :parent_associations, source_type: klass.to_s,
             dependent: :destroy, source: :parent
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
      childs_query.where(parents: parents)
    end

    def where_parent_ids(*parent_ids, type:)
      childs_query.where(parent_ids: parent_ids, parents_type: type)
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def childs_query
      MultiparentTree::ChildsQuery.new(klass: self)
    end
  end
end
