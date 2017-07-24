class AddCloseRelativeToChildrenParents < ActiveRecord::Migration[5.1]
  def change
    add_column :children_parents, :close_relative, :boolean, null: true, index: true
  end
end
