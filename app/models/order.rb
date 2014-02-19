class Order < ActiveRecord::Base
  
  belongs_to :tour, :counter_cache => 'orders_count'
  belongs_to :user, :counter_cache => 'orders_count'
  
  scope :ios, -> { where("type = 'IosOrder'")}
  scope :android, -> { where("type = 'AndroidOrder'")}
  
  delegate :name, :url, :build_id, :country, :city, :to => :tour, :prefix => true
end
