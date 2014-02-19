require 'digest'

class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :login, :default => "admin"
      t.string :password, :default => Digest::MD5.hexdigest('123456')

      t.timestamps
    end

    Admin.create!(:login => "admin", :password => Digest::MD5.hexdigest('123456'))
  end

  def self.down
    drop_table :admins
  end
end
