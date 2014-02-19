class AddCategoriesIdsToPobsBundles < ActiveRecord::Migration
  def self.up
    add_column :pobs_bundles, :categories_ids, :string
  end

  def self.down
    remove_column :pobs_bundles, :categories_ids
  end
end
