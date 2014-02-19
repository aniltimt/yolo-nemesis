require 'spec_helper'

describe 'Default route' do
  it 'GET /' do
    {:get => '/'}.should route_to(
      :controller => 'admin/dashboard',
      :action     => 'index'
    )
  end

  it 'GET /admin' do
    {:get => '/admin'}.should route_to(
      :controller => 'admin/dashboard',
      :action     => 'index'
    )
  end
end
