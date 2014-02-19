class ChangeLatlngInPobsTable < ActiveRecord::Migration
  def self.up
    remove_column :pobs, :pob_point

    change_column :pobs, :longitude, :decimal, :precision => 12, :scale => 6, :null => false
    change_column :pobs, :latitude, :decimal, :precision => 12, :scale => 6, :null => false
    add_index :pobs, :longitude
    add_index :pobs, :latitude
  end

  def self.down
    add_column :pobs, :pob_point, :point

    remove_index :pobs, :longitude
    remove_index :pobs, :latitude
    change_column :pobs, :longitude, :float, :null => false
    change_column :pobs, :latitude, :float, :null => false
  end
end
