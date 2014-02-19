class AddIsUbertourColumnToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :is_ubertour, :boolean, :default => false
    add_index :tours, [:client_id, :is_ubertour]
  end

  def self.down
    remove_column :tours, :is_ubertour
  end
end
