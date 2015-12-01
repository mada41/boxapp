class AddInvitedUserAndBoxesHabtm < ActiveRecord::Migration
  def change
  	create_table :boxes_users do |t|
      t.integer :box_id
      t.integer :user_id
    end
    add_index :boxes_users, :box_id
    add_index :boxes_users, :user_id
  end
end
