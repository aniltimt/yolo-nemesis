class TourVisitor
  def initialize(modelClass)
    @modelClass = modelClass
    @current_country = @current_city = nil
  end
  
  def visit(hash)
    hash.each do |key, value|
      method = "visit_#{key}_#{value.class}"
      send(method, value) if respond_to?(method)
    end
  end
  
  def visit_places_Hash(place)
    visit(place)
  end
  
  def visit_country_Hash(country)
    @current_country = country['name']
    visit(country)
  end

  def visit_city_Hash(city)
    @current_city = city['name']
    visit(city)
  end

  def visit_country_Array(countries)
    countries.each do |country|
      visit_country_Hash(country)
    end
  end
  
  def visit_city_Array(cities)
    cities.each do |city|
      visit_city_Hash(city)
    end
  end
  
  def visit_tour_Array(tours)
    tours.each do |tour|
      visit_tour_Hash(tour)
    end
  end
  
  # real fun and work is done here
  def visit_tour_Hash(tour)
    modelInstance = @modelClass.find_or_initialize_by_id(tour['tourID'].to_i)

    attrs = {
      :build_id => tour['latestBuild'].to_i,
      :name     => tour['name'],
      :url      => tour['url'],
      :is_ubertour => tour['is_ubertour'],
      :client_id => tour['client_id'],
      :country  => @current_country,
      :city     => @current_city
    }
    attrs.merge!({:subtours_count => tour['subtours_count'].to_i}) if tour['subtours_count']

    if !tour['subtours'].blank?
      tour['subtours'].split(',').each do |subtour_id|
        if ! TourUbertour.find_by_tour_id_and_ubertour_id(subtour_id.to_i, tour['tourID'].to_i)
          TourUbertour.create! :tour_id => subtour_id.to_i, :ubertour_id => tour['tourID'].to_i
        end
      end
    end

    modelInstance.update_attributes(attrs)
  end
end
