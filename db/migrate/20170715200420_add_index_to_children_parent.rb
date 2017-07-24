class AddIndexToChildrenParent < ActiveRecord::Migration[5.1]
  def change
    add_index :categories, :updated_at
    add_index :children_parents,
              %i[children_type parent_type parent_id],
              name: 'index_children_parents_both_types_and_parent_id'
  end
end
