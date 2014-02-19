require 'zip/zip'

class PobsBundle < ActiveRecord::Base
  belongs_to :tour

  after_create :compress_package
  before_destroy :clear_files

  attr_accessor :pobs

  def pobs=(pobs)
    @pobs = pobs
  end

  def filtered_categories
    cats = self.categories_ids.to_s.split(',').map(&:to_i)
    # 50 means dirty WiFi category
    PobCategory.where(:id => cats).where("parent_id IS NOT NULL OR id = 50").select([:id]).map { |c| c.id }
  end

  def self.root
    File.join(Rails.public_path, 'pob_bundles')
  end

  def pobs_bundle_root
    File.join(PobsBundle.root, self.id.to_s)
  end

  def categories
    self.categories_ids.split(",").map(&:to_i)
  end

  def pobs_bundle_xml_name
    "pobs.xml"
  end

  def coupons_xml_name
    "coupons.xml"
  end

  def banners_xml_name
    "banners.xml"
  end

  def tour_xml_path
    File.join(content_root, pobs_bundle_xml_name)
  end

  def pobs_bundle_name
    # http://wiki.kyiv.cogniance.com/display/DFEP/POBs+synchronization
    # if record was already persisted then use persisted timestamp (so when used later pobs_bundle_name wouldn't change)
    @bundle_name ||= if self.created_at 
      "#{self.created_at.utc.to_i}.pack"
    else
      "#{Time.current.utc.to_i}.pack"
    end
  end

  # memoizing the result since we use Time.current here (and it could change)
  def pobs_bundle_path
    @pobs_bundle_path ||= File.join(pobs_bundle_root, pobs_bundle_name)
  end

  # memoizing the result since we use Time.current here (and it could change)
  def pobs_bundle_s3_uri
    @pobs_bundle_s3_uri ||= "#{self.tour_id}/#{self.id}/#{pobs_bundle_name}"
  end

  def bundle_xml_s3_url
    S3_URL + "#{current_s3_bucket}/#{pobs_bundle_xml_s3_uri}"
  end

  def pobs_bundle_s3_url
    S3_URL + "#{current_s3_bucket}/#{pobs_bundle_s3_uri}"
  end

  def current_s3_bucket
    S3_POBS_BUCKET_NAME
  end

  def destroy_s3_files
    initialize_s3

    obj = @s3.buckets[current_s3_bucket].objects[pobs_bundle_s3_uri]
    obj.delete if obj
  end

  def generate_pobs_xml
    returning(pobs_xml = "") do
      xml = Builder::XmlMarkup.new(:target => pobs_xml)
      xml.instruct!
      xml.pobs do |pobs|
        @pobs.each do |pob|
          pob_hash = {:id => pob.id, :latitude => pob.latitude, :longitude => pob.longitude, :iconUrl => "", :icon => (pob.icon.blank? ? "" : "icons/#{File.basename(pob.icon.url)}"), :name => pob.name, :address => pob.address, :city => pob.city, :country => pob.country, :shortDescription => pob.description}
          if !pob.price_range.blank?
            pob_hash[:cost] = pob.price_range
          end
          pobs.pob(pob_hash) do |pob_el|
            pob_el.categories do |cats|
              pob.pob_categories.each do |pob_cat|
                if self.categories.include? pob_cat.id
                  cats.category(:id => pob_cat.id)
                end
              end
            end

            pob_el.description(pob.description)
            if !pob.open_hours.blank?
              pob_el.workingHours(pob.open_hours)
            end
            pob_el.contacts do |pob_contacts|
              if !pob.address.blank?
                pob_contacts.contact(:type => "address", :value => pob.address)          
              end
              if !pob.phone.blank?
                pob_contacts.contact(:type => "phone", :value => pob.phone)          
              end
              if !pob.url.blank?
                pob_contacts.contact(:type => "website", :value => pob.url)          
              end
              if !pob.email.blank?
                pob_contacts.contact(:type => "email", :value => pob.email)          
              end
            end

            pob_el.media do |pob_media|
              pob.pob_images.each do |pob_image|
                pob_media.medium :'content-type' => "image/jpeg", :url => "media/#{pob_image.id}/#{File.basename(pob_image.image.url)}", :description => ""
              end
              if !pob.txt_file.blank?
                pob_media.medium :'content-type' => "text/plain", :url => "media/#{File.basename(pob.txt_file.url)}", :description => ""
              end
            end

            pob_el.coupons do |pob_coupons|
              pob.coupons.each do |coupon|
                pob_coupons.coupon :id => coupon.id
              end
            end

            pob_el.banners do |pob_banners|
              pob.banners.each do |banner|
                if banner.banner_type == "pob"
                  pob_banners.banner :id => banner.id
                end
              end
            end
          end
        end
      end
    end
  end

  def generate_coupons_xml()
    returning(coupons_xml = "") do
      xml = Builder::XmlMarkup.new(:target => coupons_xml)
      xml.instruct!
      xml.coupons do |coupons|
        coupons_to_render = []
        @pobs.each do |pob|
          pob.coupons.each do |coupon|
            coupons_to_render << coupon
          end
        end
        coupons_to_render.uniq.each do |pob_coupon|
          coupon_hash = {:id => pob_coupon.id, :name => pob_coupon.name, :image => "coupons/#{pob_coupon.id}/#{File.basename(pob_coupon.image.url)}"}
          coupons.coupon(coupon_hash) do |coupon_el|
            if !pob_coupon.banners.empty?
              coupon_el.banners do |banners|
                banners.banner :id => pob_coupon.banners.first.id
              end
            end
          end
        end
      end
    end
  end

  def generate_banners_xml
    returning(banners_xml = "") do
      xml = Builder::XmlMarkup.new(:target => banners_xml)
      xml.instruct!
      xml.banners do |banners|
        banners_to_render = []
        @pobs.each do |pob|
          pob.banners.each do |banner|
            banners_to_render << banner
          end
        end
        banners_to_render.uniq.each do |pob_banner|
          if pob_banner.banner_type == "pob"
            banners.banner :id => pob_banner.id, :text => pob_banner.text, :backgroundColor => pob_banner.bg_color, :textColor => pob_banner.text_color
          else
            banners.banner :id => pob_banner.id, :image => "banners/#{pob_banner.id}/#{File.basename(pob_banner.image.url)}"
          end
        end
      end
    end
  end

  def clear_files
    FileUtils.rm_rf(pobs_bundle_path) && destroy_s3_files
  end

private

  def add_file(name, data)
    @new_files ||= { }
    @new_files[name] = data
  end

  def compress_package
    @pobs.each do |pob|
      if !pob.icon.blank? && File.exists?(pob.icon.path)
        add_file("icons/#{File.basename(pob.icon.url)}", File.read(pob.icon.path))
      end

      pob.pob_images.each do |image|
        if File.exists?(image.image.path)
          add_file("media/#{image.id}/#{File.basename(image.image.url)}", File.read(image.image.path))
        end
      end

      pob.coupons.each do |coupon|
        if File.exists?(coupon.image.path)
          add_file("coupons/#{coupon.id}/#{File.basename(coupon.image.url)}", File.read(coupon.image.path))
        end
        coupon.banners.each do |banner|
          if File.exists?(banner.image.path)
            add_file("banners/#{banner.id}/#{File.basename(banner.image.url)}", File.read(banner.image.path))
          end
        end
      end
      if !pob.txt_file.blank?
        add_file("media/#{File.basename(pob.txt_file.url)}", File.read(pob.txt_file.path))
      end
    end

    add_file(pobs_bundle_xml_name, generate_pobs_xml)
    add_file(coupons_xml_name, generate_coupons_xml)
    add_file(banners_xml_name, generate_banners_xml)

    update_link_to_s3

    @new_files ||= { }
    @new_files.each_pair do |fname, content|
      write_to_build fname, content
    end
    # pack all files to one .pack which will be stored in s3

    all_bundle_files = Dir["#{pobs_bundle_root}/**/**"]
    write_package_files(all_bundle_files)
    initialize_s3
    push_pobs_bundle_to_s3
  end

  def update_link_to_s3
    # must be updated here because :id of bundle is available after save (so link to S3 would be correct)
    update_attribute :link_to_bundle, pobs_bundle_s3_uri
  end

  def write_package_files(files_list)
    files = []
    directories = []

    files_list.each do |ent|
      if File.directory?(ent)
        directories << ent
      else
        files << ent
      end
    end

    FileUtils.mkdir_p(pobs_bundle_root) if !File.exists?(pobs_bundle_root)

    File.open(pobs_bundle_path, "wb") do |f|
      f << [directories.size].pack("N")
      f << directories.map{ |dir| pack_relative_path(dir)}.join
      f << [files.size].pack("N")
      files.each do |file_name|
        f << pack_relative_path(file_name)
        f << [File.size(file_name)].pack("N")
        f << File.read(file_name)
      end
    end
  end

  def pack_relative_path(str)
    str = str.gsub(pobs_bundle_root, '')
    [str.length, str].pack("NA#{str.length}")
  end

  def write_to_build(fname, content)
    full_path = File.expand_path(fname, pobs_bundle_root)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.open(full_path, "w"){ |f| f.write content}
  end

  def initialize_s3   

    @s3 = AWS::S3.new(
      :access_key_id     => S3_ACCESS_KEY,
      :secret_access_key => S3_SECRET
    )
    
    if !@s3.buckets.collect(&:name).include?(current_s3_bucket)
      Rails.logger.warn "creating #{current_s3_bucket}"
      @s3.buckets.create(current_s3_bucket)
    end
  end

  def push_pobs_bundle_to_s3
    begin
      if File.exists?(pobs_bundle_path)
        @s3.buckets[current_s3_bucket].objects[pobs_bundle_s3_uri].write File.open(pobs_bundle_path, 'r')
      end
    rescue Errno::ENOENT => e
      puts "there's no pobs bundle on local filesystem: #{e.message}"
    end
  end
end
