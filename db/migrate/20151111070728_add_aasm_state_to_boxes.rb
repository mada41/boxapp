class AddAasmStateToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :aasm_state, :string
  end
end
