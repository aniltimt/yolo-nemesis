xml.instruct!

xml.places(:count => @products.size) do
  @products.each_pair do |country, country_tours|
    country_cities = country_tours.map(&:city).uniq
    xml.country(:name => country, :citiesCount => country_cities.size, :toursCount => country_tours.size) do
      country_cities.each do |city|
        xml.city :name => city, :toursCount => Product.in_country(country).in_city(city).count, :url => market_country_city_path(country, city)
      end
    end
  end
end
