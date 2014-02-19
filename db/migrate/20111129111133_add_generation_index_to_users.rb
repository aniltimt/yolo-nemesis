class AddGenerationIndexToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :generation_index, :integer, :default => 1
    add_index :users, [:client_id, :generation_index]

    add_column :clients, :last_generation_index, :integer, :default => 1
  end

  def self.down
    remove_index :users, [:client_id, :generation_index]
    remove_column :users, :generation_index

    remove_column :clients, :last_generation_index
  end
end
