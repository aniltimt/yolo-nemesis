class Coupon < ActiveRecord::Base
  belongs_to :pob
  has_many :banners, :dependent => :destroy

  validates_associated :pob
  validates_presence_of :name, :image

  attr_accessible :name, :image, :image_url, :image_cache

  # carrierwave
  mount_uploader :image, CouponImageUploader

  after_save :find_affected_tours
  before_destroy :find_affected_tours

  def find_affected_tours
    self.pob.try(:find_affected_tours)
  end
end
