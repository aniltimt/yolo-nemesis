class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.text :text
      t.string :name
      t.references :pob
      t.references :coupon
      t.string :image
      t.string :banner_type

      t.timestamps
    end
    add_index :banners, :pob_id
    add_index :banners, :coupon_id
  end

  def self.down
    drop_table :banners
  end
end
