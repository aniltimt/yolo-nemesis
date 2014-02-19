class AddJointTablePobsPobCategories < ActiveRecord::Migration
  def self.up
    create_table :pob_categories_pobs, :id => false do |t|
      t.integer :pob_id
      t.integer :pob_category_id
    end

    add_index :pob_categories_pobs, [:pob_id, :pob_category_id]
  end

  def self.down
    drop_table :pob_categories_pobs
  end
end
