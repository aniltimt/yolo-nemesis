require 'spec_helper'

describe Client do
  describe "creation of client" do
    it "should return error if name is blank" do
      Client.create(:email => 'dsamoilov@cogniance.com').errors.full_messages.should include("Name can't be blank")
    end

    it "should return error if name is blank" do
      Client.create(:name => 'My Hotel').errors.full_messages.should include("Email can't be blank")
    end

    it "should return error if name is blank" do
      users_num = 0
      c = Client.create(:email => 'dsamoilov@cogniance.com', :name => "My Hotel")
      c.errors.should == {}
      c.name.should == "My Hotel"
      c.email.should == "dsamoilov@cogniance.com"
      c.password.length.should == 7
      c.tours.should == []
      c.reload

      c.users.count.should == 1
      user = c.users.where(:is_preview_user => true).first
      user.email.should == "dsamoilov@cogniance.com"
      user.encrypted_password.should be
    end

    it "should not be clients with not uniq emails and names" do
      Client.create!(:email => 'dsamoilov@cogniance.com', :name => "My Hotel")
      c = Client.create(:email => 'dsamoilov@cogniance.com', :name => "My Hotel")
      c.errors.full_messages.should include("Email has already been taken")
      c.errors.full_messages.should include("Name has already been taken")
    end
  end

  # there are 3 types of tours: generic for a ordinal DF iphone app, branded (for a particular tbu like Hilton) and open only for special pregenerated users for a particular tbu
  describe "setting permissions for particular user" do
    before(:each) do
      @tour1 = FactoryGirl.create(:tour, :id => 45)
      @tour2 = FactoryGirl.create(:tour, :id => 46)
      @shared_tour = FactoryGirl.create(:tour, :id => 47)
    end

    #it "should return error if name is blank" do
    #  c = Client.create(:email => 'dsamoilov@cogniance.com', :name => "My Hotel")
    #  c.tours << 
    #  c.roles.should 
    #end
  end
end

describe Client, "can't be saved when email is" do
  let(:client) { FactoryGirl.build :client }
  MarketApi::Application.config.reserved_emails.each do |m|
    it m do
      client.email = m
      client.save
      client.should have(1).errors
    end
  end
end
