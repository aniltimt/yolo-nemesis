class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :name, :null => false
      t.string :image, :null => false
      t.references :pob

      t.timestamps
    end
    add_index :coupons, :pob_id
  end

  def self.down
    drop_table :coupons
  end
end
