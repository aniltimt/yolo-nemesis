class RenameIconUrlToUrlInPobs < ActiveRecord::Migration
  def self.up
    rename_column :pobs, :icon_url, :url
  end

  def self.down
    rename_column :pobs, :url, :icon_url
  end
end
