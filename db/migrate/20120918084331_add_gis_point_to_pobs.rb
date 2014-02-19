class AddGisPointToPobs < ActiveRecord::Migration
  def self.up
    add_column :pobs, :pob_point, :point, :null => false
    add_index :pobs, :pob_point

    Pob.reset_column_information

    execute "UPDATE pobs SET pob_point = PointFromText(CONCAT('POINT(',pobs.longitude,' ',pobs.latitude,')'));"
  end

  def self.down
    remove_column :pobs, :pob_point
  end
end
