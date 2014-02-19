require 'spec_helper'

describe 'iOS Order routes' do
  it 'POST /v1/ios/orders' do
    {:post => '/v1/ios/orders'}.should route_to(
      :controller => 'v1/ios/orders',
      :action     => 'create'
    )
  end
end