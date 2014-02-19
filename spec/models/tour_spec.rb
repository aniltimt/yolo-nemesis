require 'spec_helper'

describe Tour do
  [:id, :city, :name, :country, :build_id, :url].each do |attribute|
    it "allows to mass assign #{attribute} attr" do
      (tour = Tour.new(attribute => 40)).save
    
      tour[attribute].to_i.should == 40
    end
  end
  
  it "sets free to false by default" do
    Tour.new.free.should be_false
  end

  it "should be generic if otherwise specified" do
    FactoryGirl.create(:tour).status.should == 'generic'
  end

  describe "#top_popular" do
    before do
      19.downto(14) do |i|
        tour = FactoryGirl.create(:tour)
        i.times do
          order = FactoryGirl.build(:order)
          order.tour = tour
          order.save
        end
      end
      5.times { FactoryGirl.create(:tour) }
    end

    it "returns :count tours ordered by count of orders" do
      Tour.top_popular(5).map { |t| t.orders.count }.should == [19, 18, 17, 16, 15]
    end

    it "should not return tours with zero orders" do
      Tour.top_popular.map{|t| t.orders.count }.should_not include(0)
    end
  end
end
