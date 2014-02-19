require 'spec_helper'

describe 'Order routes' do
  it 'GET /v1/orders' do
    {:get => '/v1/orders'}.should route_to(
      :controller => 'v1/orders',
      :action     => 'index'
    )
  end

  it 'GET /v1/orders/:id' do
    {:get => '/v1/orders/1'}.should route_to(
      :controller => 'v1/orders',
      :action     => 'show',
      :id         => '1'
    )
  end
end