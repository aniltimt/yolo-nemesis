require 'spec_helper'

describe 'v1/places/index.builder' do
  
  include OrderHelper
  
  before do
    @tours = 5.times.map { |i| FactoryGirl.build(:tour, :id => i) }
    
    @tours[2].free = true
    
    assign(:places, @tours)
    render
  end
  
  it 'contains all elements' do
    data = Hash.from_xml(rendered)
    
    tours = data['places']['country']['city']['tour']
    
    @tours.each_with_index do |tour, index|
      tours[index]['name'].should == tour.name
      tours[index]['tourID'].should == tour.id.to_s
      tours[index]['latestBuild'].should == tour.build_id.to_s
      tours[index]['url'].should == tour_xml_url(tour)
      tours[index].should have_key('free') if tour.free?
    end
  end
end
