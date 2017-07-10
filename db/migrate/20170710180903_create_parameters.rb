class CreateParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :parameters do |t|
      t.string :ru_title
      t.string :en_title
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
