require 'spec_helper'

describe 'Tours routes' do
  it 'GET /admin/tours' do
    {:get => '/admin/tours'}.should route_to(
      :controller => 'admin/tours',
      :action     => 'index'
    )
  end
  
  it 'POST /admin/tours/:id/free' do
    { :post => '/admin/tours/1/free' }.should route_to(
      :controller => "admin/tours",
      :action => "free",
      :id => '1'
    )
  end
  
  it 'POST /admin/tours/:id/paid' do
    { :post => '/admin/tours/1/paid' }.should route_to(
      :controller => "admin/tours",
      :action => "paid",
      :id => '1'
    )
  end
end
