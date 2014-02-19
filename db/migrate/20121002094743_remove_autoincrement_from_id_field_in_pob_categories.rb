class RemoveAutoincrementFromIdFieldInPobCategories < ActiveRecord::Migration
  def self.up
    remove_column :pob_categories, :cat_id
    remove_column :pob_categories, :id
    remove_column :pob_categories, :parent_id

    add_column :pob_categories, :id, :integer, :null => false
    add_column :pob_categories, :parent_id, :integer
  end

  def self.down
    add_column :pob_categories, :cat_id, :integer
  end
end
