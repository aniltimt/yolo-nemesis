class V1::ProductsController < ApplicationController
  respond_to :all, :only => [:map, :media]
  before_filter :authenticate_user!, :only => [:map, :media]
  before_filter :load_build, :only => [:map, :media]

  def map
    if Amazon::S3::S3Object.exists?(@product.map_pack_path, @product.bucket)
      send_file S3Object.value(@product.map_pack_path, @product.bucket)
    else
      render :status => 404
    end
  end

  def media
    if Amazon::S3::S3Object.exists?(@product.map_pack_path, @product.bucket)
      send_file Amazon::S3::S3Object.value(@product.tour_pack_path, @product.bucket)
    else
      render :status => 404
    end
  end

  protected
    def load_build
      @product = Product.find params[:id]
    end
end
