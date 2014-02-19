require 'spec_helper'

describe Admin::PobsController do
  before do
    @pobs = 10.times.map { FactoryGirl.create(:pob, :pob_categories => [FactoryGirl.create(:pob_category)], :pob_images => [FactoryGirl.create(:pob_image)]) }
  end

  describe 'authenticated user' do
    before do
      session[:_admin_logged_in] = true
    end

    describe 'GET /admin/pobs' do
      before do
        get :index
      end

      it_behaves_like "OK response"
    
      it 'assigns pobs to @pobs' do
        assigns(:pobs).should =~ @pobs
      end
    
      it 'renders admin/pobs/index template' do
        response.should render_template('admin/pobs/index')
      end
    end
    
    describe 'POST /admin/pobs/create' do
      before do
        pbc = FactoryGirl.create(:pob_category)
        post :create, :pob => {:country => "UK", :name => "Big Ben", :address => "Westminster Bridge", :description => "Big Ben is the nickname for the great bell of the clock at the north end of the Palace of Westminster in London, and is generally extended to refer to the clock and the clock tower as well", :longitude => -0.124527, :latitude => 51.500727, :pob_category_ids => [pbc.id.to_s], :icon => File.open("spec/support/fixtures/media/gary_oldman.jpg"), :pob_images_attributes => { "0"=>{"image" => File.open("spec/support/fixtures/media/gary_oldman.jpg") }} }
      end
      
      it_behaves_like "redirect response"
      
      it 'assigns pob to @pob' do
        assigns(:pob).should be
      end
      
      it 'saves @pob w/o errors' do
        assigns(:pob).errors.should == {}
      end
      
      it 'should redirect to admin/pobs/show' do
        response.should redirect_to(admin_pobs_url(assigns(:pob).id))
      end
    end

    describe 'POST /admin/pobs/create with missing name and latitude' do
      before do  
        @pbc = FactoryGirl.create(:pob_category)      
        post :create, :pob => {:country => "UK", :name => "", :description => "Big Ben is the nickname for the great bell of the clock at the north end of the Palace of Westminster in London, and is generally extended to refer to the clock and the clock tower as well", :longitude => nil, :latitude => nil, :pob_category_ids => [@pbc.id.to_s]}
      end
      
      it 'assigns pob to @pob' do
        assigns(:pob).should be
      end
      
      it 'saves @pob w/ errors' do
        assigns(:pob).errors[:name].should_not == []
        assigns(:pob).errors[:latitude].should_not == []
        assigns(:pob).errors[:longitude].should_not == []
        assigns(:pob).errors[:address].should_not == []
        assigns(:pob).id.should == nil
        assigns(:pob).pob_category_ids.should == [@pbc.id]
      end
      
      it 'should redirect to admin/pobs/new back' do
        response.should render_template('admin/pobs/new')
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
