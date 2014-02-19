class AddFreeToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :free, :boolean, :default => false
  end

  def self.down
    remove_column :tours, :free
  end
end
