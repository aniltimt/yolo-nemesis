FactoryGirl.define do
  factory :tour do
    sequence(:id) {|n| n}
    name      "History of religion"
    build_id  5
    country   "UA"
    city      "Kyiv"
    url {"http://s3.amazon.com/tours_development/#{country}/#{city}/1/#{build_id}.xml"}

    association :client
    aasm_state :initial
  end
end
