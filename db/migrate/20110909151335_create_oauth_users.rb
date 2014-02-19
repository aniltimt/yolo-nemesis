class CreateOauthUsers < ActiveRecord::Migration
  def self.up
    create_table :oauth_users do |t|
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.integer :user_id

      t.string :email
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :name

      t.timestamps
    end

    add_index :oauth_users, [:provider, :uid]
    add_index :oauth_users, :oauth_token
    add_index :oauth_users, :email
  end

  def self.down
    drop_table :oauth_users
  end
end
