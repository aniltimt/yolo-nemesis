require 'spec_helper'

describe 'admin/tours/_tour.html' do
  [:id, :name].each do |attribute|
    it "contains tour #{attribute}" do
      tour = FactoryGirl.build(:tour, :id => 1)
      render(:partial => 'admin/tours/tour', :locals => {:tour => tour})
      rendered.should include(tour[attribute].to_s)
    end
  end
  
  it 'contains Mark as Free button if tour is marked as payed' do
    tour = FactoryGirl.build(:tour, :id => 1)
    render(:partial => 'admin/tours/tour', :locals => {:tour => tour})
    rendered.should include('Mark as Free')
  end

  it 'contains Mark as Paid button if tour is marked as free' do
    tour = FactoryGirl.build(:tour, :id => 1, :free => true)
    render(:partial => 'admin/tours/tour', :locals => {:tour => tour})
    rendered.should include('Mark as Paid')
  end
  
  it 'sets action td id to action_#{tour_id}' do
    tour = FactoryGirl.build(:tour, :id => 5)
    render(:partial => 'admin/tours/tour', :locals => {:tour => tour})
    rendered.should =~ /<td\s+id='action_5'\s*>/
  end
end
