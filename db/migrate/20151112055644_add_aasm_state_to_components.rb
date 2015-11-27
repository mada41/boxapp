class AddAasmStateToComponents < ActiveRecord::Migration
  def change
    add_column :components, :aasm_state, :string
  end
end
