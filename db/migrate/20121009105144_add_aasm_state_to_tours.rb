class AddAasmStateToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :aasm_state, :string
    add_index  :tours, :aasm_state
  end

  def self.down
    remove_column :tours, :aasm_state
  end
end
