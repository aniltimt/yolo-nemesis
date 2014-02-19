class AddSaltFieldToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :salt, :string

    admin = Admin.first
    if admin
      salt = Rails.env.production? ? "qrQYIc8CXRaJW2DQnaC1" : "CNdizBMn526UDTgGPbmo" 
      new_password = Devise::Encryptors::Sha1.digest('123456', 10, salt, '')
      admin.password = new_password
      admin.salt = salt
      admin.save
    end
  end

  def self.down
    remove_column :admins, :salt
  end
end
