require 'spec_helper'

describe AppleReceipt do
  describe 'attributes' do
    it 'initializes from hash object' do
      apple_receipt = AppleReceipt.new(receipt(1))
      apple_receipt.product_id.should == receipt(1)[:product_id]
    end
    
    it 'strips com.digitalfootsteps.tour. from id if it is present' do
      AppleReceipt.new({:product_id => 'com.digitalfootsteps.tour.15'}).product_id.should == '15'
    end
  end
end
