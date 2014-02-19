class AddReceiptToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :receipt, :text
  end

  def self.down
    remove_column :orders, :receipt
  end
end
