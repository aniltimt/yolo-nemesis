class AddClientIdToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :client_id, :integer
    add_column :tours, :status, :string, :default => "generic", :nil => false

    add_index :tours, :client_id
    add_index :tours, :status
  end

  def self.down
    remove_column :tours, :client_id
    remove_column :tours, :status
  end
end
