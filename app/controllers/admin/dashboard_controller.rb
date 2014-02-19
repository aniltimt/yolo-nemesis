class Admin::DashboardController < Admin::ApplicationController
  def index
    @registrations = User.registrations_by_month
    @top_buyers = User.top_buyers(5)
    @top_popular = Tour.top_popular(5)
  end
end
