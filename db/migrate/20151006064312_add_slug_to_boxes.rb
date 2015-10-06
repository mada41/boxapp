class AddSlugToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :slug, :string
    add_index :boxes, :slug
  end
end
