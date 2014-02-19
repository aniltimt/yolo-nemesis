require 'spec_helper'

describe Order do
  before do
    @order = FactoryGirl.create(:order)
  end
  [:name, :url, :build_id, :country, :city].each do |method|
    it "delegates tour_#{method} to tour.#{method}" do
      @order.send("tour_#{method}").should == @order.tour.send(method)
    end
  end
end