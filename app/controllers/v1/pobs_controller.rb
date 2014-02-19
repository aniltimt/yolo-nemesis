class V1::PobsController < ApplicationController
  skip_before_filter :authenticate_by_token!

  def create_bundle
    @categories_list = params[:categories]
    @tour_id         = params[:tour_id]

    @se = params[:se]
    @nw = params[:nw]

    if @se.blank? || @nw.blank? || @tour_id.blank?
      render(:text => "failed", :status => 403) and return
    end

    @se = @se.split(',').map(&:to_f) # lat, lng
    @nw = @nw.split(',').map(&:to_f) # lat, lng

    @pobs = Pob.find_by_sql ["SELECT * FROM pobs LEFT JOIN pob_categories_pobs pcp ON pcp.pob_id = pobs.id WHERE pcp.pob_category_id IN (?) AND pobs.latitude BETWEEN #{@se[0]} AND #{@nw[0]} AND pobs.longitude BETWEEN #{@nw[1]} AND #{@se[1]}", @categories_list.split(',').map{|c| c.to_i}]

puts "SELECT * FROM pobs WHERE pobs.latitude BETWEEN #{@se[0]} AND #{@nw[0]} AND pobs.longitude BETWEEN #{@nw[1]} AND #{@se[1]}"

puts Pob.find_by_sql("SELECT * FROM pobs WHERE pobs.latitude BETWEEN #{@se[0]} AND #{@nw[0]} AND pobs.longitude BETWEEN #{@nw[1]} AND #{@se[1]}").inspect


    pobs_bundle = PobsBundle.new

    pobs_bundle.south = @se[0]
    pobs_bundle.east = @se[1]
    pobs_bundle.north = @nw[0]
    pobs_bundle.west = @nw[1]

    pobs_bundle.pobs = @pobs.uniq
    pobs_bundle.tour_id = @tour_id
    pobs_bundle.categories_ids = @categories_list.split(',').map{|c| c.to_i}.compact.join(',')
    pobs_bundle.save

    render :text => 'success', :status => 200
  end

  def sync
    tour_ids = params[:tour_ids].split(',').map{|id| id.strip.to_i}
    timestamp = params[:timestamp]

    tours = Tour.find tour_ids

    if timestamp.blank? || tour_ids.blank? || tours.blank?
      render(:json => {:result => "failed"}.to_json, :status => 403) and return
    end

    @s3 = AWS::S3.new(
      :access_key_id     => S3_ACCESS_KEY,
      :secret_access_key => S3_SECRET
    )

    obj_urls = {}
    tours.map(&:get_last_pobs_bundle).compact.each do |last_pobs_bundle|
      if last_pobs_bundle.created_at.utc.to_i > timestamp.to_i
        obj = @s3.buckets[S3_POBS_BUCKET_NAME].objects[last_pobs_bundle.link_to_bundle.to_s]
        obj_urls[last_pobs_bundle.tour_id] = obj.url_for(:read, :secure => false, :expires => 1.year).to_s
      end
    end

    render :json => {:result => "success", :pobs_bundles_urls => obj_urls, :timestamp => Time.current.utc.to_i}.to_json
  rescue ActiveRecord::RecordNotFound => e
    render :json => {:result => "failed", :status => e.message}.to_json, :status => 404
  rescue => e
    render :json => {:result => "failed"}.to_json, :status => 403
  end
end
