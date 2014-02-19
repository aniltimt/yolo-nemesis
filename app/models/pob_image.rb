class PobImage < ActiveRecord::Base
  belongs_to :pob

  attr_accessible :image, :image_cache, :pob_id

  validates_presence_of :image

  # carrierwave
  mount_uploader :image, PobImageUploader
end
