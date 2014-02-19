class AddColorSettingsToBanners < ActiveRecord::Migration
  def self.up
    add_column :banners, :bg_color, :string
    add_column :banners, :text_color, :string
  end

  def self.down
    remove_column :banners, :text_color
    remove_column :banners, :bg_color
  end
end
