require 'spec_helper'

describe 'Statistics routes' do
  it 'GET /admin/statistics/top_buyers' do
    {:get => '/admin/statistics/top_buyers'}.should route_to(
      :controller => 'admin/statistics',
      :action     => 'top_buyers'
    )
  end

  it 'GET /admin/statistics/top_popular_tours' do
    {:get => '/admin/statistics/top_popular_tours'}.should route_to(
      :controller => 'admin/statistics',
      :action     => 'top_popular_tours'
    )
  end
end
