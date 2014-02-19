require 'spec_helper'

describe "User Orders routes" do
  it 'GET /admin/users/1/orders' do
    {:get => '/admin/users/1/orders'}.should route_to(
      :controller => 'admin/orders',
      :action     => 'index',
      :user_id    => '1'
    )
  end
end
