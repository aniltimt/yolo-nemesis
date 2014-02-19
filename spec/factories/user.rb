FactoryGirl.define do
  factory :user do
    email
    password 'letmein'
    authentication_token 
  end
end
