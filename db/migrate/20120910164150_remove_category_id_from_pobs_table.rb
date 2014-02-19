class RemoveCategoryIdFromPobsTable < ActiveRecord::Migration
  def self.up
    remove_column :pobs, :pob_category_id
  end

  def self.down
    add_column :pobs, :pob_category_id, :null => false
  end
end
