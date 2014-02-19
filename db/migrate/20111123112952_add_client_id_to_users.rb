class AddClientIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :client_id, :integer
    add_index :users, :client_id
  end

  def self.down
    remove_column :users, :client_id
  end
end
