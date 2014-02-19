class AddOrderCountCacheToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :orders_count, :integer, :default => 0
    add_index :users, :orders_count
    User.reset_column_information
    User.all.each do |user|
      User.reset_counters user.id, :orders
    end
  end

  def self.down
    remove_column :users, :orders_count
  end
end
