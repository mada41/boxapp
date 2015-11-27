class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :c_type
      t.string :name
      t.integer :box_id

      t.timestamps null: false
    end
    add_index :components, :box_id
  end
end
