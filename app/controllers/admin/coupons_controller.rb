class Admin::CouponsController < Admin::ApplicationController

  before_filter :set_defaults

  def index
    @page = params[:page] || 1
    @coupons = Coupon.where(:pob_id => @pob.id).order('created_at DESC').paginate(:page => @page, :per_page => 30)
    @coupons_count = Coupon.count
  end

  def new
    @coupon = Coupon.new
    session[:return_to_coupons] = request.env["HTTP_REFERER"] || admin_pob_coupons_path(@pob)
  end

  def show
  end

  def search 
    relation = Coupon
    if params[:coupon]
      @coupon_name = params[:coupon][:name]
      relation = @coupon_name.blank? ? relation : relation.where(['coupons.name LIKE ?', "%#{@coupon_name}%"])
    end

    @page = params[:page] || 1
    @coupons_count = relation.count
    @coupons = relation.paginate(:page => @page, :per_page => 30)
  end

  def create
    @coupon = Coupon.new(params[:coupon])  
    @coupon.pob_id = @pob.id
    if !@coupon.save
      flash.now[:error] = "Sorry, there were errors while creating new coupon"
      render(:action => :new)
    else
      set_flash_notice @coupon, "created"
      redirect_to admin_pob_coupons_path
    end
  end

  def edit
    @coupon = Coupon.find params[:id]
    session[:return_to_coupons] = request.env["HTTP_REFERER"] || admin_pob_coupons_path(@pob)
  end

  def update
      @coupon = Coupon.find(params[:id])
      @coupon.pob_id = @pob.id
      if @coupon.update_attributes(params[:coupon])
        set_flash_notice @coupon, "updated"
        redirect_to session[:return_to_coupons]
      else
        flash.now[:error] = "Sorry, there were errors while updating #{@coupon.name}"
        render(:action => :edit)
      end
  end

  def destroy
    @coupon = Coupon.find params[:id]
    if @coupon.destroy
      set_flash_notice @coupon, "deleted"
      redirect_to admin_pob_coupons_url
    else
      flash[:error] = "Sorry, there were errors while deleting coupon called #{@pob.name}"
      redirect_to(:back)
    end
  end
 
  private
    def set_defaults
      if params[:pob_id]
        @pob = Pob.find params[:pob_id]
      end
    end

    def set_flash_notice(coupon, action)
        flash[:notice] = "You've successfully #{action} coupon called #{coupon.name}. ".html_safe
        if Tour.edited.count > 0
          flash[:notice] << "<br />There is <a href='/admin/tours/pending' class='btn btn-warning'>pending</a> tours".html_safe
        end
    end
end

