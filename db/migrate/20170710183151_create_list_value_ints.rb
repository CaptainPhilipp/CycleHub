class CreateListValueInts < ActiveRecord::Migration[5.1]
  def change
    create_table :list_value_ints do |t|
      t.integer :value

      t.timestamps
    end
  end
end
