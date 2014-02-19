class AddFiledsToTours < ActiveRecord::Migration
  def self.up
    change_table :tours do |t|
      t.string :name
      t.string :url
      t.integer :build_id
    end
  end

  def self.down
    remove_column :tours, :name
    remove_column :tours, :url
    remove_column :tours, :build_id
  end
end
