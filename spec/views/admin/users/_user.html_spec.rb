require 'spec_helper'

describe 'admin/users/_user.html' do
  [:id, :email].each do |attribute|
    it "contains user #{attribute}" do
      user = FactoryGirl.build(:user, :id => 1)
      render(:partial => 'admin/users/user', :locals => {:user => user})
      rendered.should include(user[attribute].to_s)
    end
  end
  
  it 'contains Orders button' do
    user = FactoryGirl.build(:user, :id => 1)
    render(:partial => 'admin/users/user', :locals => {:user => user})
    rendered.should include('Orders')
  end
end
