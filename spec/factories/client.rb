FactoryGirl.define do
  factory :client do
    sequence(:name) {|n| "User#{n}"}
    email
    sequence(:password) { |n| "!ertPI4527$#{n}" }
    #sequence(:preview_password) { |n| "!ertPI4527$#{n}" }
    sequence(:api_key) { |n| "12345678#{n}" }
  end
end
