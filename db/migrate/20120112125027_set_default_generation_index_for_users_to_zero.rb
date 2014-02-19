class SetDefaultGenerationIndexForUsersToZero < ActiveRecord::Migration
  def self.up
    change_column :users, :generation_index, :integer, :default => 0
    change_column :clients, :last_generation_index, :integer, :default => 0
  end

  def self.down
    change_column :users, :generation_index, :integer, :default => 1
    change_column :clients, :last_generation_index, :integer, :default => 1
  end
end
