FactoryGirl.define do
  #factory :user do
  #  email 'john@example.com'
  #end

  factory :product do
    city { Faker::Address.city }
    country { Faker::Address.country }
    name { Faker::Lorem.sentence }
  end
end
