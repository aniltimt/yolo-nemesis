FactoryGirl.define do
  factory :pob_image do
    image {File.new("spec/support/fixtures/media/gary_oldman.jpg")}
  end
end
