class DeleteTypeFromComponents < ActiveRecord::Migration
  def change
  	remove_column :components, :type
  end
end
