class Pob < ActiveRecord::Base
  has_and_belongs_to_many :pob_categories
  has_many :pob_images
  has_many :coupons, :dependent => :destroy
  has_many :banners, :dependent => :destroy

  validates_associated :pob_categories
  validates_presence_of :name, :country, :pob_categories
  validates_presence_of :longitude, :latitude, :address, :unless => lambda {|pob| pob.draft?}

  accepts_nested_attributes_for :pob_images, :reject_if => :all_blank, :allow_destroy => true

  attr_accessible :pob_images, :url, :country, :name, :city, :address, :longitude, :latitude, :pob_category_ids, :description, :icon, :icon_cache, :image_cache, :pob_images_attributes, :price_range, :open_hours, :email, :phone, :txt_file

  # carrierwave
  mount_uploader :icon, IconUploader
  mount_uploader :txt_file, PobTxtUploader

  attr_writer :draft # defined to determine whether this POB is added through script to draft categories or it's 
                       # added manually

  after_save :find_affected_tours
  after_save :xmlize_txt_file, :unless => lambda {|pob| pob.txt_file.blank?}

  before_destroy :find_affected_tours

  def xmlize_txt_file
    # please forgive me
    txt = File.read(self.txt_file.path)
    if txt[0..4] == '<?xml'
      return
    end

    xmlized_content = ""
    xml = Builder::XmlMarkup.new(:target => xmlized_content)
    xml.instruct!
    xml.data do
      xml.text do |t|
        t << self.txt_file.read   #  doing 't << value' rather then 'xml.text value' will save the value w/o encoding into html entities
      end
    end
    File.open(self.txt_file.path, 'w') do |f|
      f.write xmlized_content.force_encoding("UTF-8")
    end
  end
  
  def find_affected_tours
    affected_pob_bundles = PobsBundle.where(['south <= :lat AND 
                                              north >= :lat AND 
                                              west <= :long AND 
                                              east >= :long', 
                                              {:lat => self.latitude, :long => self.longitude}]).all
    if !affected_pob_bundles.blank?
      affected_pob_bundles.each do |pob_bundle|
        # if at least one category matched
        intersection = self.pob_categories.map(&:id) & pob_bundle.filtered_categories
        if !intersection.empty?
          pob_bundle.tour.try(:touch!)
        end
      end
    end
  end

  def draft?
    !! @draft
  end
end
