class Admin::BannersController < Admin::ApplicationController

  before_filter :set_defaults

  def index
    @page = params[:page] || 1
    @banners = Banner.where(:pob_id => @pob.id).order('created_at DESC').paginate(:page => @page, :per_page => 30)
    @banner_count = Banner.count
  end

  def new
    @banner = Banner.new
    @banner.banner_type = :pob

    prepare_coupons
    session[:return_to_banners] = request.env["HTTP_REFERER"] || admin_pob_banners_path(@pob)
  end

  def search 
    relation = Banner
    if params[:banner]
      @banner_name = params[:banner][:name]
      @banner_type = params[:banner][:type]

      relation = @banner_name.blank? ? relation : relation.where(['banners.name LIKE ?', "%#{@banner_name}%"])
      relation = @banner_type.blank? ? relation : relation.where(['banners.banner_type = ?', @banner_type])
    end

    @page = params[:page] || 1
    @banners_count = relation.count
    @banners = relation.paginate(:page => @page, :per_page => 30)
  end

  def create
    @banner = Banner.new(params[:banner])  
    if !@banner.save
      prepare_coupons
      flash.now[:error] = "Sorry, there were errors while creating new banner"
      render(:action => :new)
    else
      set_flash_notice @banner, "created"
      redirect_to admin_pob_banners_path
    end
  end

  def edit
    @banner = Banner.find params[:id]
    prepare_coupons
    if @banner.banner_type == 'coupon'
      @coupons << Coupon.find(@banner.coupon_id)
    end
    session[:return_to_banners] = request.env["HTTP_REFERER"] || admin_pob_banners_path(@pob)
  end

  def update
      @banner = Banner.find(params[:id])
      if @banner.update_attributes(params[:banner])
        set_flash_notice @banner, "updated"
        redirect_to session[:return_to_banners]
      else
        prepare_coupons
        flash.now[:error] = "Sorry, there were errors while updating #{@banner.name}"
        render(:action => :edit)
      end
  end

  def destroy
    @banner = Banner.find params[:id]
    if @banner.destroy
      set_flash_notice @banner, "deleted"
      redirect_to admin_pob_banners_url
    else
      flash[:error] = "Sorry, there were errors while deleting coupon called #{@banner.name}"
      redirect_to(:back)
    end
  end
 
  private
    def set_defaults
      if params[:pob_id]
        @pob = Pob.find params[:pob_id]
      end
    end

    def set_flash_notice(banner, action)
        flash[:notice] = "You've successfully #{action} banner called #{banner.name}. ".html_safe
        if Tour.edited.count > 0
          flash[:notice] << "<br />There is <a href='/admin/tours/pending' class='btn btn-warning'>pending</a> tours".html_safe
        end
    end

    def prepare_coupons
      @coupons = []
      @pob.coupons.each do |coupon|
        if coupon.banners.empty?
          @coupons << coupon
        end
      end
    end
end


