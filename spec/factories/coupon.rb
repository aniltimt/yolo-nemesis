FactoryGirl.define do
  factory :coupon do
    sequence(:name) {|n| "Coupon #{n}"}
    image nil    
    created_at Time.now
    updated_at Time.now
  end
end

