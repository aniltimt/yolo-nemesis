require 'spec_helper'

describe Admin::CouponsController do
  before do
    @pob = FactoryGirl.create(:pob, :pob_categories => [FactoryGirl.create(:pob_category)], :pob_images => [FactoryGirl.create(:pob_image)]) 
    @coupons = 10.times.map do
      FactoryGirl.create(:coupon, {:image => File.new("spec/support/fixtures/media/gary_oldman.jpg"), :pob => @pob}) 
    end
  end

  describe 'authenticated user' do
    before do
      session[:_admin_logged_in] = true
    end

    describe 'GET /admin/pobs/1/coupons' do
      before do
        get :index, :pob_id => '1'
      end

      it_behaves_like "OK response"
    
      #it 'assigns pob to @pob' do
        #assigns(:pob).should =~ @pob
      #end

      it 'assigns coupons to @coupons' do
        assigns(:coupons).should =~ @coupons
      end
    
      it 'renders admin/coupons/index template' do
        response.should render_template('admin/coupons/index')
      end
    end
    
    describe 'POST /admin/pobs/1/create' do
      before do
        post :create, :pob_id => '1', :coupon => {:name => "Coupon 1", :image => File.open("spec/support/fixtures/media/gary_oldman.jpg"), :pob_id => 1}
      end
      
      it_behaves_like "redirect response"
      
      it 'assigns pob to @pob' do
        assigns(:pob).should be
      end

      it 'assigns coupon to @coupon' do
        assigns(:coupon).should be
      end
      
      it 'saves @coupon without errors' do
        assigns(:coupon).errors.should == {}
      end
      
      it 'should redirect to coupons list' do
        response.should redirect_to(admin_pob_coupons_url(assigns(:pob).id))
      end
    end
  end

  
  describe 'not authenticated user' do
    before do
      get :index, :pob_id => '1'
    end

    it_behaves_like "authentication required"
  end
end

