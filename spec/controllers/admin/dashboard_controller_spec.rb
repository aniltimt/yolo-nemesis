require 'spec_helper'

describe Admin::DashboardController do
  describe 'authenticated admin' do
    describe "GET /admin/dashboard" do
      before do
        #@request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(ADMIN_LOGIN, ADMIN_PASSWD)
        #post '/admin/login', {:login => ADMIN_LOGIN, :password => ADMIN_PASSWD}
        session[:_admin_logged_in] = true

        User.stub(:registrations_by_month).and_return([["Jan", 100], ["Feb", 75]])
        @top_buyers = 5.times.map do |i|
          user = FactoryGirl.build(:user)
          user.orders << i.times.map { FactoryGirl.build(:order) }
        end.reverse
        @top_popular = 5.times.map do |i|
          tour = FactoryGirl.build(:tour)
          tour.orders << i.times.map { FactoryGirl.build(:order) }
        end.reverse
        User.stub(:top_buyers).with(5).and_return(@top_buyers)
        Tour.stub(:top_popular).with(5).and_return(@top_popular)
        get :index
      end

      it_behaves_like "OK response"

      it "assigns array of year, count combinations to @registrations" do
        assigns(:registrations).should == [["Jan", 100], ["Feb", 75]]
      end

      it "assigns array of users soted by number of orders" do
        assigns(:top_buyers).should == @top_buyers
      end

      it "assigns array of tours soted by number of orders" do
        assigns(:top_popular).should == @top_popular
      end
    end
  end

  describe "not authenticated admin" do
    before do
      get :index
    end

    it_behaves_like "authentication required"
  end
end
