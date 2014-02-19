class Banner < ActiveRecord::Base
  TYPE_CHOICES = {'pob' => 'Text', 'coupon' => 'Coupon'}
  COLORS = ['000000', 'FFFFFF', '9C9056', '3C4B5E', 'B26132', 'D7A95B', '6D8C7C', '53363B', '003442', 'AC1A25', 'D67929', 'EFE7C0']
  belongs_to :pob
  belongs_to :coupon

  validates_inclusion_of :banner_type, :in => TYPE_CHOICES
  validates_presence_of :name
  validates_presence_of :image, :coupon, :if => Proc.new { |banner|
    banner.banner_type == 'coupon'
  }
  validates_presence_of :text, :if => Proc.new { |banner|
    banner.banner_type == 'pob'
  }
  validates_associated :pob
  validate :validate_image_dimension


  # carrierwave
  mount_uploader :image, BannerImageUploader

  before_save :type_transformations
  after_save :find_affected_tours
  before_destroy :find_affected_tours

  def validate_image_dimension
    geometry = self.image.geometry
    if (!geometry.nil?)
      width, height = geometry[0], geometry[1]
      unless width == 640 and height == 100
          errors.add :image, "Invalid dimension. Valid is 640x100px." 
      end
    end
  end


  def type_transformations
    if self.banner_type == 'pob'
      self.coupon_id = nil
    end
  end

  def find_affected_tours
    self.pob.find_affected_tours
  end
end
