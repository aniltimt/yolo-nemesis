require 'spec_helper'

describe AndroidReceipt do
  before do
    @receipt_json = ActiveSupport::JSON.encode(android_receipt(['tour.1', 'tour.2']))
    @signature = sign_android_receipt(@receipt_json)
    @android_receipt = AndroidReceipt.new(@receipt_json, @signature)
  end

  it 'correctly validates valid receipt' do
    @android_receipt.valid?.should == true
  end
  
  it 'correctly validates invalid receipt' do
    invalid_receipt = AndroidReceipt.new('invalid json', 'invalid signautre')
    invalid_receipt.valid?.should == false
  end

  it 'returns correct product ids as array' do
    @android_receipt.product_ids.should == ['1', '2']
  end
end

