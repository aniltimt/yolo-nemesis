class AddIsPublishedToTours < ActiveRecord::Migration
  def self.up
    add_column :tours, :is_published, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :tours, :is_published
  end
end
