class AddAdditionalFieldsToPobs < ActiveRecord::Migration
  def self.up
    add_column :pobs, :open_hours, :string
    add_column :pobs, :price_range, :string
    add_column :pobs, :phone, :string
    add_column :pobs, :email, :string
  end

  def self.down
    remove_column :pobs, :email
    remove_column :pobs, :phone
    remove_column :pobs, :price_range
    remove_column :pobs, :open_hours
  end
end
