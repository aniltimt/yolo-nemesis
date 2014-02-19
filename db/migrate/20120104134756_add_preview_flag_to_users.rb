class AddPreviewFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_preview_user, :boolean, :default => false
    #add_column :clients, :preview_password, :string

    #password_symbols = (["A".."Z", "a".."z", 1..9].map(&:to_a).flatten + ['!','$'])

    Client.all.each do |client|
      u = User.find_by_email(client.email)
      if u
        u.is_preview_user = true
        u.client = client
        u.save
      else
        user = User.create! :email => client.email, :password => client.password, :is_preview_user => true
        user.client = client
        user.save
      end
    end
  end

  def self.down
    User.where(:is_preview_user => true).map{|u| u.destroy}
    remove_column :users, :is_preview_user
  end
end
