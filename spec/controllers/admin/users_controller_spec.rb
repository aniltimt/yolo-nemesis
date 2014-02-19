require 'spec_helper'

describe Admin::UsersController do
  describe "authenticated admin" do
    before do
      session[:_admin_logged_in] = true
    end

    describe "GET /admin/users" do
      before do
        @users = 30.times.map { FactoryGirl.create(:user) }
        get :index
      end

      it_behaves_like "OK response"

      it 'assigns users to @users and check the size' do
        assigns(:users).size.should == @users.size
      end

      it 'renders admin/users/index template' do
        response.should render_template('admin/users/index')
      end
    end
  end

  describe 'not authenticated admin' do
    before do
      get :index
    end

    it_behaves_like "authentication required"
  end

  describe "loggin in as client" do
    before do
      @client = FactoryGirl.create :client
    end

    it "should get a list of all client's tours" do
    end
  end
end
