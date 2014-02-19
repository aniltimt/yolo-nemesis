class AddPreviewUserForAdmin < ActiveRecord::Migration
  def self.up
    if Rails.env.production?
      u = User.find_by_email 'waldmanjulie@gmail.com'
      if !u
        User.create! :email => 'waldmanjulie@gmail.com', :password => '123456', :is_preview_user => true
      end
    elsif Rails.env.qa?
      u = User.find_by_email 'aminiailo@cogniance.com'
      if !u
        User.create! :email => 'aminiailo@cogniance.com', :password => '123456', :is_preview_user => true
      end
    end
  end

  def self.down
  end
end
