require 'spec_helper'
include ActionDispatch::TestProcess 

describe Coupon do
  before(:each) do
    @pob = FactoryGirl.create :pob, :pob_categories => [FactoryGirl.create(:pob_category)], :pob_images => [FactoryGirl.create(:pob_image)]
    @coupon = FactoryGirl.build(:coupon, {:pob => @pob, :image => File.new("spec/support/fixtures/media/gary_oldman.jpg")})
  end

  it "should validate name" do 
    @coupon.name = nil
    @coupon.save.should be_false
  end

  it "should validate image" do 
    # build new instance here because no way to override image value
    @coupon = FactoryGirl.build(:coupon, {:pob => @pob})
    @coupon.save.should be_false
  end

  it "creates valid model" do
    @coupon.save.should be_true
  end
end
