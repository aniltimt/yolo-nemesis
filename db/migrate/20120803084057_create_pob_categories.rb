class CreatePobCategories < ActiveRecord::Migration
  def self.up
    create_table :pob_categories do |t|
      t.integer :parent_id
      t.string :name, :null => false
      t.timestamps
    end

    add_index :pob_categories, :parent_id
    add_index :pob_categories, [:id, :parent_id], :unique => true
  end

  def self.down
    drop_table :pob_categories
  end
end
