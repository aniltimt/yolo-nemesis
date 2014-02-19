require 'spec_helper'

describe 'admin/users/index.html' do
  describe 'no users available' do
    it 'does not render user partial' do
      assign(:users, [])
      assign(:type, 'registered')
      assign(:current_page, 1)
      assign(:num_of_pages, 1)
      render
      view.should_not render_template(:partial => 'admin/users/_user')
    end
  end
  
  describe 'there are some users' do
    it 'renders user partial for all users' do
      users = 5.times.map { |i| FactoryGirl.build(:user, :id => i) }
      assign(:users, users)
      assign(:type, 'registered')
      assign(:current_page, 1)
      assign(:num_of_pages, 1)
      render
      view.should render_template(:partial => 'admin/users/_user', :count => 5)
    end
  end
end
