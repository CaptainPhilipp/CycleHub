class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :ru_title
      t.string :en_title
      t.integer :depth

      t.timestamps
    end
  end
end
