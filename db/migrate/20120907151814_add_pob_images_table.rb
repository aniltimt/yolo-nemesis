class AddPobImagesTable < ActiveRecord::Migration
  def self.up
    remove_column :pobs, :icon_file_name
    remove_column :pobs, :icon_content_type
    remove_column :pobs, :icon_file_size

    add_column :pobs, :icon, :string
    
    create_table :pob_images do |t|
      t.references :pob
      t.string :image
    end

    add_index :pob_images, :pob_id
  end

  def self.down
    add_column :pobs, :icon_file_name, :string
    add_column :pobs, :icon_content_type, :string
    add_column :pobs, :icon_file_size, :integer

    remove_column :pobs, :icon

    drop_table :pob_images
  end
end
