require 'spec_helper'

describe IosOrder do
  before do
    @tour = FactoryGirl.create(:tour, :id => 45)
    @user = FactoryGirl.create(:user)
    #@receipt = android_receipt("com.abc." << @tour.id.to_s).to_json
    #@signature = sign_android_receipt receipt
  end

  it 'accepts receipt and sets tour_id to product_id after_validation' do
    order = IosOrder.new(:user => @user, :receipt => receipt_from_ios)
    order.valid?
    order.tour_id.should == @tour.id
  end
  
  [:receipt_json, :receipt_json=].each do |method|
    it "responds to #{method}" do
      IosOrder.new.should respond_to(method)
    end
  end
  
  it 'validates receipt if tour is not free' do
    order = IosOrder.new(:user => @user, :tour_id => 45)
    order.should_not be_valid
  end
  
  it 'does not validate receipt if tour is free' do
    order = IosOrder.new(:user => @user, :tour_id => FactoryGirl.create(:tour, :free => true).id)
    order.should be_valid
  end
end
