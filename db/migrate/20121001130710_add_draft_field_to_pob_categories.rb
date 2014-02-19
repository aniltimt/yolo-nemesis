class AddDraftFieldToPobCategories < ActiveRecord::Migration
  def self.up
    add_column :pob_categories, :cat_id, :integer
    add_column :pob_categories, :is_draft, :boolean, :default => false
  end

  def self.down
    remove_column :pob_categories, :cat_id
    remove_column :pob_categories, :is_draft
  end
end
