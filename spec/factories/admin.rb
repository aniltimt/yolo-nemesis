require 'digest'

FactoryGirl.define do
  factory :admin do
    login 'admin'
    salt "Fh5lj_LpMbDlYRJMwBGf"
    password "3ca740fcbb28c990743af53f4aab098feaf44969"
  end
end
