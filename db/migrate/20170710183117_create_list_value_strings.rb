class CreateListValueStrings < ActiveRecord::Migration[5.1]
  def change
    create_table :list_value_strings do |t|
      t.string :ru_title
      t.string :en_title

      t.timestamps
    end
  end
end
