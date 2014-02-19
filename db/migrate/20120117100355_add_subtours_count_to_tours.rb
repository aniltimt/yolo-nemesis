class AddSubtoursCountToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :subtours_count, :integer, :default => 0
  end

  def self.down
    remove_column :tours, :subtours_count
  end
end
