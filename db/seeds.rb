# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


Admin.create!(:login => "admin1", :password => Digest::MD5.hexdigest('123456'))
 

PobCategory.delete_all

@restaurant_pob = PobCategory.create(:name => "Restaurant", :id => 1)
PobCategory.create(:name => "Asian", :parent_id => @restaurant_pob.id, :id => 2)
PobCategory.create(:name => "Bar/Pub", :parent_id => @restaurant_pob.id, :id => 3)
PobCategory.create(:name => "Bar/Pub (draft)", :parent_id => @restaurant_pob.id, :id => 4, :is_draft => true)
PobCategory.create(:name => "Cafe", :parent_id => @restaurant_pob.id, :id => 5)
PobCategory.create(:name => "Cafe (draft)", :parent_id => @restaurant_pob.id, :id => 6, :is_draft => true)
PobCategory.create(:name => "French", :parent_id => @restaurant_pob.id, :id => 7)
PobCategory.create(:name => "Italian", :parent_id => @restaurant_pob.id, :id => 8)
PobCategory.create(:name => "Japanese/ Sushi", :parent_id => @restaurant_pob.id, :id => 9)
PobCategory.create(:name => "Japanese/ Sushi (draft)", :parent_id => @restaurant_pob.id, :id => 10, :is_draft => true)
PobCategory.create(:name => "Kosher", :parent_id => @restaurant_pob.id, :id => 11)
PobCategory.create(:name => "Seafood", :parent_id => @restaurant_pob.id, :id => 12)
PobCategory.create(:name => "Seafood (draft)", :parent_id => @restaurant_pob.id, :id => 13, :is_draft => true)
PobCategory.create(:name => "Other", :parent_id => @restaurant_pob.id, :id => 14)
PobCategory.create(:name => "Other (draft)", :parent_id => @restaurant_pob.id, :id => 15, :is_draft => true)


@shopping_pob = PobCategory.create(:name => "Shopping", :id => 16)
PobCategory.create(:name => "Clothes",              :parent_id => @shopping_pob.id, :id => 17)
PobCategory.create(:name => "Drug Store",           :parent_id => @shopping_pob.id, :id => 18)
PobCategory.create(:name => "Drug Store (draft)",   :parent_id => @shopping_pob.id, :id => 19, :is_draft => true)
PobCategory.create(:name => "Electronics",          :parent_id => @shopping_pob.id, :id => 20)
PobCategory.create(:name => "Gift Shop/ Souvenirs", :parent_id => @shopping_pob.id, :id => 21)
PobCategory.create(:name => "Groceries",            :parent_id => @shopping_pob.id, :id => 22)
PobCategory.create(:name => "Liquor Store",         :parent_id => @shopping_pob.id, :id => 23)
PobCategory.create(:name => "Mall",                 :parent_id => @shopping_pob.id, :id => 24)
PobCategory.create(:name => "Shoes",                :parent_id => @shopping_pob.id, :id => 25)
PobCategory.create(:name => "Other",                :parent_id => @shopping_pob.id, :id => 26)

@accommodation_pob = PobCategory.create(:name => "Accommodation", :id => 27)
PobCategory.create(:name => "Hotel", :parent_id => @accommodation_pob.id, :id => 28)
PobCategory.create(:name => "Hotel (draft)", :parent_id => @accommodation_pob.id, :id => 29, :is_draft => true)
PobCategory.create(:name => "Hostel", :parent_id => @accommodation_pob.id, :id => 30)
PobCategory.create(:name => "Hostel (draft)", :parent_id => @accommodation_pob.id, :id => 31, :is_draft => true)
PobCategory.create(:name => "Bed and Breakfast", :parent_id => @accommodation_pob.id, :id => 32)
PobCategory.create(:name => "Other", :parent_id => @accommodation_pob.id, :id => 33)

@entertainment_pob = PobCategory.create(:name => "Entertainment", :id => 34)
PobCategory.create(:name => "Bar/Pub",      :parent_id => @entertainment_pob.id, :id => 35)
PobCategory.create(:name => "Cinema",       :parent_id => @entertainment_pob.id, :id => 36)
PobCategory.create(:name => "Cinema (draft)",:parent_id => @entertainment_pob.id, :id => 37, :is_draft => true)
PobCategory.create(:name => "Concert Hall", :parent_id => @entertainment_pob.id, :id => 38)
PobCategory.create(:name => "Concert Hall (draft)", :parent_id => @entertainment_pob.id, :id => 39, :is_draft => true)
PobCategory.create(:name => "Disco Club",   :parent_id => @entertainment_pob.id, :id => 40)
PobCategory.create(:name => "Opera House",  :parent_id => @entertainment_pob.id, :id => 41)
PobCategory.create(:name => "Stadium",      :parent_id => @entertainment_pob.id, :id => 42)
PobCategory.create(:name => "Stadium (draft)",      :parent_id => @entertainment_pob.id, :id => 43, :is_draft => true)
PobCategory.create(:name => "Theatre",      :parent_id => @entertainment_pob.id, :id => 44)
PobCategory.create(:name => "Theatre (draft)", :parent_id => @entertainment_pob.id, :id => 45, :is_draft => true)
PobCategory.create(:name => "Theme park",   :parent_id => @entertainment_pob.id, :id => 46)
PobCategory.create(:name => "Theme park (draft)",   :parent_id => @entertainment_pob.id, :id => 47, :is_draft => true)
PobCategory.create(:name => "Other",        :parent_id => @entertainment_pob.id, :id => 48)
PobCategory.create(:name => "Other (draft)", :parent_id => @entertainment_pob.id, :id => 49, :is_draft => true)

PobCategory.create(:name => "Wifi spots", :id => 50)

@services_pob = PobCategory.create(:name => "Services", :id => 51)
PobCategory.create(:name => "Bank",      :parent_id => @services_pob.id, :id => 52)
PobCategory.create(:name => "Money changer",       :parent_id => @services_pob.id, :id => 53)
PobCategory.create(:name => "Laundromat",       :parent_id => @services_pob.id, :id => 54)
PobCategory.create(:name => "Cleaner",       :parent_id => @services_pob.id, :id => 55)
PobCategory.create(:name => "Gym",       :parent_id => @services_pob.id, :id => 56) 
PobCategory.create(:name => "Hospital",       :parent_id => @services_pob.id, :id => 57)
PobCategory.create(:name => "Pharmacy",       :parent_id => @services_pob.id, :id => 58)
