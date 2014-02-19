class AddUniqueIndexOnUserIdTourIdToOrders < ActiveRecord::Migration
  def self.up
    add_index :orders, [:user_id, :tour_id], :unique => true
  end

  def self.down
    remove_index :orders, [:user_id, :tour_id]
  end
end
