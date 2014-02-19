FactoryGirl.define do
  factory :pob do
    sequence(:name) {|n| "Pob #{n}"}
    country "Ireland"
    city "Dublin"
    address "Main Street 15"
    description ""
    latitude { 51.500727 + rand(200)*0.01 }
    longitude  { -0.124527 + rand(150)*0.01 }
    icon {File.new("spec/support/fixtures/media/gary_oldman.jpg")}
    created_at Time.now
    updated_at Time.now
    price_range "100"
    open_hours "100"
    url "http://example.com"
    phone "12345678"
    email "email@example.com"
    association :pob_images, :factory => :pob_image
    association :pob_categories, :factory => :pob_category
  end
end
