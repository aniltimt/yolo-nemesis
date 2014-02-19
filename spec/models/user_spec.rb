require 'spec_helper'

describe User do
  describe "#name_or_email" do
    it "returns email if user has no name" do
      User.new(:email => 'mkrekoten@cogniance.com').name_or_email.should == 'mkrekoten@cogniance.com'
    end
  end

  describe "#registrations_by_year" do
    it "returns array of year and count combinations" do
      dates = 5.times.map { |i| Time.now - i.years }.reverse
      5.times.map { |i| FactoryGirl.create(:user, :created_at => dates[i]) }
      User.registrations_by_year.should == dates.map { |date| [date.year.to_s, 1] }
    end
  end

  describe "#registrations_by_month" do
    it "returns array of month and count combinations" do
      monthes = 5.times.map { |i| Time.now - i.month }.reverse
      5.times.map { |i| FactoryGirl.create(:user, :created_at => monthes[i]) }
      User.registrations_by_month.should == monthes.map { |date| [date.strftime('%b'), 1] }
    end
  end

  describe "#top_buyers" do
    before do
      10.downto(5) do |i|
        user = FactoryGirl.create(:user)
        i.times do
          order = FactoryGirl.create(:order)
          order.user = user
          order.save
        end
      end
      5.times { FactoryGirl.create(:user) }
    end

    it "returns :count users ordered by count of orders" do
      User.top_buyers(5).map { |u| u.orders.count }.should == [10, 9, 8, 7, 6]
    end

    it "returns :count users ordered by count of orders" do
      User.top_buyers.map { |u| u.orders.count }.should_not include(0)
    end
  end
end
