require 'spec_helper'

describe Admin::StatisticsController do
  describe "authenticated admin" do
    before do
      #@request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(ADMIN_LOGIN, ADMIN_PASSWD)
      session[:_admin_logged_in] = true
    end
    
    describe "GET /admin/statistics/top_buyers" do
      before do
        @top_buyers = 5.times.map do |i|
          user = FactoryGirl.build(:user)
          user.orders << i.times.map { FactoryGirl.build(:order) }
        end.reverse
        User.stub(:top_buyers).and_return(@top_buyers)

        get :top_buyers
      end

      it_behaves_like "OK response"

      it "assigns top buyers array to @top_buyers" do
        assigns(:top_buyers).should == @top_buyers
      end
    end

    describe "GET /admin/statistics/top_popular_tours" do
      before do
        @top_popular = 5.times.map do |i|
          tour = FactoryGirl.build(:tour)
          tour.orders << i.times.map { FactoryGirl.build(:order) }
        end.reverse
        Tour.stub(:top_popular).and_return(@top_popular)

        get :top_popular_tours
      end

      it_behaves_like "OK response"

      it "assigns top popular tours array to @top_popular" do
        assigns(:top_popular).should == @top_popular
      end
    end
  end

  describe 'not authenticated admin' do
    before do
      get :top_buyers
    end

    it_behaves_like "authentication required"
  end
end
