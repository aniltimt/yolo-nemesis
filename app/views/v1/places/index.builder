@places_grouped = @places.group_by { |t| t.country }

xml.instruct!
xml.places(:count => @places_grouped.size) do
  @places_grouped.each_pair do |country, country_tours|
    country_cities = country_tours.map(&:city).uniq
    xml.country(:name => country, :citiesCount => country_cities.size, :toursCount => country_tours.size) do
      country_cities.each do |city|
        tours_in_city = @places.select { |tour| tour.country == country && tour.city == city }
        xml.city :name => city, :toursCount => tours_in_city.count do
          tours_in_city.each do |tour|
            opts = {
              :name => tour.name, 
              :url => tour_xml_url(tour),
        			:tourID => tour.id,
              :is_ubertour => tour.is_ubertour,
        			:latestBuild => tour.build_id
            }
            opts[:free] = true if tour.free?
            opts[:purchased] = true if @user && Order.find_by_tour_id_and_user_id(tour.id, @user.id)
            opts[:skipAppStore] = true if @user && @user.is_preview_user
            opts[:subtours_count] = tour.subtours_count if tour.is_ubertour
            xml.tour(opts)
          end
        end
      end
    end
  end
end
