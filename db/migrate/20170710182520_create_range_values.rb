class CreateRangeValues < ActiveRecord::Migration[5.1]
  def change
    create_table :range_values do |t|
      t.integer :from
      t.integer :upto

      t.timestamps
    end
  end
end
