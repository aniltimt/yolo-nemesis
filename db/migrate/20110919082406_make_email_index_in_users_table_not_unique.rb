class MakeEmailIndexInUsersTableNotUnique < ActiveRecord::Migration
  def self.up
    remove_index :users, :email
    add_index :users, :email, :name => "index_users_on_email"
  end

  def self.down
    remove_index :users, :email
    add_index :users, :email, :name => "index_users_on_email", :unique => true
  end
end
