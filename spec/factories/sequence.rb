FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end
  
  sequence :authentication_token do |n|
    "auth_token_#{n}"
  end
end