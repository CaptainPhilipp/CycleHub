class AddShortTitleToCategories < ActiveRecord::Migration[5.1]
  def up
    add_column :categories, :short_title, :string, index: true
    Category.find_each { |c, i| c.update short_title: i }
    change_column_null :categories, :short_title, false
  end

  def down
    remove_column :categories, :short_title
  end
end
