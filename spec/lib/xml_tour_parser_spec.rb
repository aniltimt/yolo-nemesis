require 'spec_helper'

describe XmlTourParser do
  describe 'parsing' do
    it 'correctly parses xml' do
      parser = XmlTourParser.new(fixture_content('places.xml'))
      
      # Not really double dispatch. I do not want to polute Hash and Array with accept methods
      visitorMock = Class.new do
        attr_reader :places, :countries, :cities, :tours
        def initialize
          @places = @countries = @cities = @tours = 0
        end
        
        def visit(hash)
          hash.each do |key, value|
            method = "visit_#{key}_#{value.class}"
            send(method, value) if respond_to?(method)
          end
        end
        
        def visit_places_Hash(place)
          @places += 1
          visit(place)
        end
        
        def visit_country_Hash(country)
          @countries += 1
          visit(country)
        end
        
        def visit_country_Array(countries)
          countries.each do |country|
            visit_country_Hash(country)
          end
        end
        
        def visit_city_Hash(city)
          @cities += 1
          visit(city)
        end
        
        def visit_city_Array(cities)
          cities.each do |city|
            visit_city_Hash(city)
          end
        end
        
        def visit_tour_Hash(tour)
          @tours += 1
        end
        
        def visit_tour_Array(tours)
          tours.each do |tour|
            visit_tour_Hash(tour)
          end
        end
      end.new
      parser.accept(visitorMock)
      visitorMock.places.should == 1
      visitorMock.countries.should == 2
      visitorMock.cities.should == 2
      visitorMock.tours.should == 3
    end
  end
end
