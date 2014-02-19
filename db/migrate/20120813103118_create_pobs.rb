class CreatePobs < ActiveRecord::Migration
  def self.up
    create_table :pobs do |t|
      t.string :name, :null => false
      t.string :country, :null => false
      t.text :description
      t.float :latitude, :null => false
      t.float :longitude, :null => false
      t.integer :pob_category_id, :null => false

      #t.string :address
      #t.string :phone
      #t.string :working_hours
      #t.string :closest_public_transport

      t.string :icon_url
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size

      t.timestamps
    end

    add_index :pobs, :pob_category_id
    add_index :pobs, [:country, :name], :unique => false
  end

  def self.down
    drop_table :pobs
  end
end
