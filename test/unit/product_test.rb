require 'test_helper'

class ProductTest < ActiveSupport::TestCase
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

  test "in_country method" do
    assert_equal 4, Product.in_country("US").count
    assert_equal 2, Product.in_country("UK").count
    assert_equal 1, Product.in_country("GE").count
  end

  test "in_city method" do
    assert_equal 2, Product.in_city("New York").count
  end

  test "both in_country and in_city methods" do
    assert_equal 1, Product.in_country("UK").in_city("Leeds").count
    assert_equal 2, Product.in_country("US").in_city("New York").count
  end

  test "uniqueness of name in the city scope" do
    Product.create! :country => "US", :city => "New York", :name => "Madison Square Garden"
    assert_raise ActiveRecord::RecordInvalid do
      Product.create! :country => "US", :city => "New York", :name => "Madison Square Garden"
    end
  end
end
