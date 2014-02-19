# -*- encoding: utf-8 -*-

require 'nokogiri'
require 'open-uri'
require 'zip/zip'
require 'tempfile'
require 'ruby-progressbar'

require Rails.root.join('lib', 'countries_list')

class PobParser < Nokogiri::XML::SAX::Document
  attr_accessor :pob_started, :country

  def initialize(country)
    @country = country
    @pob_name = []
    @pob_description = []

    @restaurant = PobCategory.find_by_name_and_parent_id 'Restaurant', nil
    @other_food = PobCategory.find_by_name_and_parent_id('Other (draft)', @restaurant.id)
    @pub   = PobCategory.find_by_name 'Bar/Pub (draft)'
    @cafe  = PobCategory.find_by_name 'Cafe (draft)'
    @seafood = PobCategory.find_by_name 'Seafood (draft)'
    @sushi   = PobCategory.find_by_name "Japanese/ Sushi (draft)"
    @shopping = PobCategory.find_by_name "Shopping"

    accomodation = PobCategory.find_by_name("Accommodation")
    @other_accomodation = PobCategory.find_by_name_and_parent_id("Accommodation", accomodation.id)
    @hotel = PobCategory.find_by_name("Hotel (draft)")
    @hostel = PobCategory.find_by_name("Hostel (draft)")

    @drug_store = PobCategory.find_by_name("Drug Store")
    @stadium = PobCategory.find_by_name("Stadium (draft)")
    @theme_park = PobCategory.find_by_name("Theme park (draft)")
    @theater = PobCategory.find_by_name("Theater (draft)")
    @cinema = PobCategory.find_by_name("Cinema (draft)")
    @concert_hall = PobCategory.find_by_name("Concert Hall (draft)")

    @entertainment = PobCategory.find_by_name_and_parent_id("Entertainment", nil)
    @entertainment_other = PobCategory.find_by_name_and_parent_id("Other (draft)", @entertainment.id)
  end

  def start_element(name, attributes = [])
    if name == "wpt" && !@pob_started
      @pob_started = true
      @pob = ::Pob.new :latitude => attributes[0][1].to_f, :longitude => attributes[1][1].to_f
      @pob.draft = true
    else
      @section = name.to_s
    end
  end

  def end_element(name, attributes = [])
    if name == "wpt"
      @pob_started = false
      @pob.name = @pob_name.join.split(':').last
      @pob.description = @pob_description.join
      @pob.country = @country.to_s.titleize
      @pob.pob_categories = [determine_pob_category(@pob_name.join)].compact

      @pob_name = []
      @pob_comment = []
      @pob_description = []

      return if @pob.pob_categories.empty? # we don't need empty POB's floating around

      if ! Pob.find_by_country_and_name(@country.to_s, @pob.name)
        @pob.save
        puts '@pob name - ' + @pob.name.inspect
      end
    end
  end

  def characters(val)
    case @section
      when "name"; @pob_name << val.strip
      when "desc"; @pob_description << val.strip
    end
  end

  def determine_pob_category(name)
    #Restaurant, Bar/Pub, Cafe, Other
    case name.split(':')[0].strip
    when /Concert Hall/i; @concert_hall
    when /Attraction/i; @entertainment_other
    when /Seafood/i; @seafood
    when /sushi/i; @sushi
    when /Restaurant/i; @other_food
    when /Pub/i; @pub
    when /Cafe/i; @cafe
    when /Hotel/i; @hotel
    when /Hostel/i; @hostel
    when "Stadium"; @stadium
    when "Theme park"; @theme_park
    when "Theater"; @theater
    when "Cinema"; @cinema
    when "Pharmacy"; @drug_store
    when "Guest house"; @other_accomodation
    else
      nil
    end
  end
end

def download_and_unzip_file(continent, subcont, country, state = nil)  
  poi_url = if state.nil?
    "http://downloads.cloudmade.com/#{continent}/#{subcont}/#{country}/#{country}.poi.gpx.zip"
  else
    "http://downloads.cloudmade.com/#{continent}/#{subcont}/#{country}/#{state}/#{state}.poi.gpx.zip"
  end

  poi_zipped = open(poi_url)
  t = nil

  path_to_poi_zipped = if poi_zipped.class == StringIO
    t = Tempfile.new(country.to_s, :encoding => 'ascii-8bit'); t.write(poi_zipped.read); t.close; t.path
  elsif poi_zipped.class == Tempfile
    poi_zipped.path
  end

  Zip::ZipFile.open(path_to_poi_zipped) do |zipfile|
    zipfile.each do |file|
      path = File.join('tmp', file.to_s + Time.now.nsec.to_s)
      file.extract(path)
      if block_given?
        yield(path)
      end
    end
  end

  t.unlink if t
end

namespace :pobs do
  desc "Delete all POBs from database"
  task :delete_all => :environment do
    pbar = ProgressBar.create(:total => Pob.count)
    threads = []

    threads << Thread.new do
      Pob.delete_all
    end

    # showing progress with deleting POBs
    threads << Thread.new do 
      pbar.progress = Pob.count
      sleep(2)
    end

    threads.map{|t| t.join}
  end

  desc "Import all POBs from cloudmade file into database"
  task :import => :environment do
    puts "Already have #{Pob.count} POBs"
    # get all GPX files from downloads.cloudmade.com 
    # example of the link http://downloads.cloudmade.com/africa/eastern_africa/burundi/burundi.poi.gpx.zip
    COUNTRIES.each do |continent, cont_countries|
      puts "| requesting #{continent}"

      cont_countries.each do |subcont, subcont_countries|
        puts "|-- requesting #{subcont}"

        if subcont_countries.is_a?(Hash)
          subcont_countries.each do |country, states|
            puts "|---- requesting #{country}"

            states.each do |state|
              puts "|------ requesting #{state}"

              download_and_unzip_file(continent, subcont, country, state) do |path_to_unzipped_file|
                if path_to_unzipped_file !~ /Government_and_Public_Services|Health_care|Tourism/
                  # Create a new parser
                  parser = Nokogiri::XML::SAX::Parser.new(PobParser.new(country))

                  # Feed the parser some XML
                  parser.parse(File.open(path_to_unzipped_file))
                end
              end
            end
          end
        else
          subcont_countries.each do |country|
            puts "|---- requesting #{country}"

            download_and_unzip_file(continent, subcont, country) do |path_to_unzipped_file|
puts 'path_to_unzipped_file - ' + path_to_unzipped_file.inspect
              if path_to_unzipped_file !~ /Government_and_Public_Services|Health_care|Tourism/
                # Create a new parser
                parser = Nokogiri::XML::SAX::Parser.new(PobParser.new(country))

                # Feed the parser some XML
                parser.parse(File.open(path_to_unzipped_file))
              end
            end
          end
        end

        sleep(2) # sleep for 2 seconds in order not to get banned from cloudmade
      end
    end
  end
end
