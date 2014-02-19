class AddAdressColumnToPobs < ActiveRecord::Migration
  def self.up
    add_column :pobs, :city, :string
    add_column :pobs, :address, :string

    add_index :pobs, :city
  end

  def self.down
    remove_column :pobs, :city
    remove_column :pobs, :address
  end
end
