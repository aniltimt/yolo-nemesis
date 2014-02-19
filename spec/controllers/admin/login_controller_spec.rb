require 'spec_helper'

describe Admin::LoginController do
  #describe "get login page" do
  #end

  describe "authenticating with right credentials" do
    before do
      admin = FactoryGirl.create(:admin)
      post :create, {:login => admin.login, :password => '1234567'}
    end

    it "sets session variable to true" do
      session[:_admin_logged_in].should == true
    end
  end

  describe "authenticating with invalid credentials" do
    before do
      admin = FactoryGirl.create(:admin) # must be created at least 1 admin in the DB
      post :create, {:login => 'mememe', :password => '654321'}
    end

    it "sets session variable to true" do
      session[:_admin_logged_in].should == nil
    end

    it_behaves_like "wrong authentication credentials"
  end
end
