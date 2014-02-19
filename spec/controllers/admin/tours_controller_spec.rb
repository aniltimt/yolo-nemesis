require 'spec_helper'

describe Admin::ToursController do
  before do
    @tours = 10.times.map { FactoryGirl.create(:tour) }
  end

  describe 'rebuild related POB bundles' do
    before do
      AWS.stub!

      @pob_categories = 2.times.map{ FactoryGirl.create(:pob_category) }
      @pobs = 5.times.map{ FactoryGirl.create(:pob, :pob_images => 2.times.map{FactoryGirl.create(:pob_image) }, :pob_categories => @pob_categories) }
      @tour = FactoryGirl.create(:tour)
      
      @east, @west, @north, @south = 1.01, 2.02, 3.03, 4.04

      @pobs_bundle = PobsBundle.new

      @pobs_bundle.east = @east
      @pobs_bundle.west = @west
      @pobs_bundle.north = @north
      @pobs_bundle.south = @south

      @pobs_bundle.pobs = @pobs
      @pobs_bundle.tour_id = @tour.id
      @pobs_bundle.categories_ids = @pob_categories.map(&:id).join(',')
      @pobs_bundle.save

    end

    it "should rebuild bundles properly" do
      get :rebuild_bundles, {:tours => [@tour.id]}
      pobs_bundle = @tour.pobs_bundles.last
      (pobs_bundle.east* 1000).truncate.should == (@east* 1000).truncate
      (pobs_bundle.north* 1000).truncate.should == (@north* 1000).truncate
      (pobs_bundle.west* 1000).truncate.should == (@west* 1000).truncate
      (pobs_bundle.south* 1000).truncate.should == (@south* 1000).truncate
    end
  end

  describe 'authenticated user' do
    before do
      session[:_admin_logged_in] = true
    end

    describe 'GET /admin' do
      before do
        get :index
      end

      it_behaves_like "OK response"
    
      it 'assigns tours to @tours' do
        assigns(:tours).should =~ @tours
      end
    
      it 'renders admin/tours/index template' do
        response.should render_template('admin/tours/index')
      end
    end
    
    describe 'POST /admin/tours/:id/free' do
      before do
        @tour = FactoryGirl.build(:tour, :id => 1)
        Tour.stub(:find).with(@tour.id).and_return(@tour)
        
        post :free, :id => @tour.id, :format => :js
      end
      
      it_behaves_like "OK response"
      
      it 'assigns tour to @tour' do
        assigns(:tour).should == @tour
      end
      
      it 'set @tour.free to true' do
        @tour.should be_free
      end
      
      it 'renders admin/tours/free template' do
        response.should render_template('admin/tours/free')
      end
    end

    describe 'POST /admin/tours/:id/paid' do
      before do
        @tour = FactoryGirl.build(:tour, :id => 1, :free => true)
        Tour.stub(:find).with(@tour.id).and_return(@tour)
        
        post :paid, :id => @tour.id, :format => :js
      end
      
      it_behaves_like "OK response"
      
      it 'assigns tour to @tour' do
        assigns(:tour).should == @tour
      end
      
      it 'set @tour.free to false' do
        @tour.should_not be_free
      end
      
      it 'renders admin/tours/paid template' do
        response.should render_template('admin/tours/paid')
      end
    end
  end

  describe 'not authenticated user' do
    before do
      get :index
    end

    it_behaves_like "authentication required"
  end
end
