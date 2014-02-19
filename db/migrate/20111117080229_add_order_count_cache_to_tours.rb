class AddOrderCountCacheToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :orders_count, :integer, :default => 0
    add_index :tours, :orders_count
    Tour.reset_column_information
    Tour.all.each do |tour|
      Tour.reset_counters tour.id, :orders
    end
  end

  def self.down
    remove_column :tours, :orders_count
  end
end
