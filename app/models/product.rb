class Product < ActiveRecord::Base

  validates_uniqueness_of :name, :scope => [:country, :city]

  scope :in_city, lambda{ |c| {:conditions => { :city => c}} }
  scope :in_country, lambda{ |c| {:conditions => { :country => c}} }
  #scope :country_cities, { :select => "city, country", :group => "city"}

  #def map_pack_path
  #  "map_#{self.id}" # "map.pack"
  #end

  #def tour_pack_path
  #  "tour_#{self.id}" # "tour.pack"
  #end
end
