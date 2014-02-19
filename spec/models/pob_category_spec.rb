require 'spec_helper'

#require File.expand_path(File.join(File.dirname(__FILE__),'..','spec_helper'))

describe "successfully built", PobCategory do
  before(:each) do
    @restaurant_cat = FactoryGirl.create(:pob_category, {:name => "Restaurant"})
  end

  it "constructs valid model" do
    @restaurant_cat.save.should be_true
  end

  it "should have name set" do
    @restaurant_cat.name = nil
    @restaurant_cat.save.should be_false
  end

  describe PobCategory, "child" do
    before(:each) do
      @asian_cat = FactoryGirl.create(:pob_category, {:name => "Asian", :parent_id => @restaurant_cat.id})
    end

    it "constructs valid model" do
      @asian_cat.save.should be_true
    end

    it "constructs valid model with correct parent" do
      @asian_cat.parent.should == @restaurant_cat
    end
  end
end

describe PobCategory do
  it { have_and_belong_to_many(:pobs) }
end
