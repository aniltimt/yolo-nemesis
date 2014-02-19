require 'spec_helper'

describe 'Places routes' do
  it 'GET /v1/places' do
    {:get => '/v1/places'}.should route_to(
      :controller => 'v1/places',
      :action     => 'index'
    )
  end
end