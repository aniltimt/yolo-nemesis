require 'spec_helper'

describe 'admin/tours/index.html' do
  describe 'no tours available' do
    it 'does not render tour partial' do
      assign(:tours, [])
      assign(:current_page, 1)
      assign(:type, 'all')
      assign(:total_tours, 0)
      render
      view.should_not render_template(:partial => 'admin/tours/_tour')
    end
  end
  
  describe 'there are some tours' do
    it 'renders tour partial for all tours' do
      tours = 5.times.map { |i| FactoryGirl.build(:tour, :id => i) }
      assign(:tours, tours)
      assign(:current_page, 1)
      assign(:type, 'all')
      assign(:total_tours, tours.count)
      render
      view.should render_template(:partial => 'admin/tours/_tour', :count => 5)
    end
  end
end
