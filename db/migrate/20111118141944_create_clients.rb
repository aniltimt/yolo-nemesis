class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :api_key

      t.timestamps
    end

    add_index :clients, :name
    add_index :clients, :email
  end

  def self.down
    drop_table :clients
  end
end
