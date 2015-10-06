class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :name
      t.string :user_id

      t.timestamps null: false
    end
    add_index :boxes, :user_id
  end
end
