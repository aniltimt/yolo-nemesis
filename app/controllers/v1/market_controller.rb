class V1::MarketController < ApplicationController
  respond_to :xml, :only => [:index, :show]

  skip_before_filter :authenticate_by_token!, :only => [:login, :index]

  def login
    render :layout => false
  end

  def index
    @products = Product.all.group_by{|p| p.country}
  end

  def show
    @country = params[:country]
    @city = params[:city]

    @products = Product.in_country(@country)
    @products = @products.in_city(@city) unless @city.blank?
  end
end
