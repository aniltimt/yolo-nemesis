class Admin::StatisticsController < Admin::ApplicationController
  def top_buyers
    @top_buyers = User.top_buyers
  end

  def top_popular_tours
    @top_popular = Tour.top_popular
  end
end
