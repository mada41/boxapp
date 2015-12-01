class CreateSshKeys < ActiveRecord::Migration
  def change
    create_table :ssh_keys do |t|
      t.string :name
      t.text :key_string
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :ssh_keys, :user_id
  end
end
