require 'spec_helper'

describe 'Users routes' do
  it 'GET /admin/users' do
    {:get => '/admin/users'}.should route_to(
      :controller => 'admin/users',
      :action     => 'index'
    )
  end
end
