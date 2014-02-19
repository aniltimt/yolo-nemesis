FactoryGirl.define do
  factory :pob_category do
    sequence(:name) {|n| "PobCategory#{n}"}
    sequence(:id) {|n| n}
  end
end
