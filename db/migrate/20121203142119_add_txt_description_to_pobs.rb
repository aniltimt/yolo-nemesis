class AddTxtDescriptionToPobs < ActiveRecord::Migration
  def self.up
    add_column :pobs, :txt_file, :string
  end

  def self.down
    remove_column :pobs, :txt_file
  end
end
