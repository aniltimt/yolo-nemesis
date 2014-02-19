require 'test_helper'

class MarketTest < ActionDispatch::IntegrationTest
  def setup
    Factory :product, :country => "US", :city => "New York"
    Factory :product, :country => "US", :city => "New York"
    Factory :product, :country => "US", :city => "San Francisco"
    Factory :product, :country => "US", :city => "Washington"
    Factory :product, :country => "UK", :city => "Leeds"
    Factory :product, :country => "UK", :city => "London"
    Factory :product, :country => "FR", :city => "Paris"
    Factory :product, :country => "GE", :city => "Tbilisi"
  end
=begin
  test "basic purchase from market" do
    # 1. user wants to purchase first tour for USA, New York 
    get "/market/places.xml"
    assert_response :success
    doc = Nokogiri::XML(response.body)
    us_node = doc.css('country[name=US]')
    assert_equal 3, us_node.attr('citiesCount').value.to_i
    assert_equal 4, us_node.attr('toursCount').value.to_i

    us_city = us_node.children.detect{|child| child['name'].eql?('Washington') }
    assert us_city
    path_to_tour_build = us_city.attr('url')
    assert path_to_tour_build

    get path_to_tour_build
    assert_response :success
    doc = Nokogiri::XML(response.body)

    tour = doc.css('tour').first
    assert tour
    path_to_tour_map   = tour.attr('mapUrl')
    path_to_tour_media = tour.attr('mediaUrl')

    assert path_to_tour_map
    assert path_to_tour_media

    get path_to_tour_map
    assert_response 401

    get path_to_tour_media
    assert_response 401

    # 2. he get authorized from iphone
    
    # 3. 
  end
=end
end
