require 'spec_helper'

describe V1::Ios::OrdersController do
  describe 'POST /v1/android/orders.xml' do
    describe 'successful case' do
      describe 'paid tour' do
        before do
          @tour = FactoryGirl.create(:tour, :id => 45)
          @user = FactoryGirl.create(:user)

          post :create, :order => {:receipt => receipt_from_ios}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
        end

        it 'responds with 201' do
          response.status.to_i.should == 201
        end
      
        it 'responds with Content-Type application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end
      
        it 'renders v1/ios/orders/create.xml' do
          response.should render_template('v1/ios/orders/create')
        end
      
        it 'creates new order' do
          @user.orders.ios.find_by_tour_id(@tour.id).should_not be_nil
        end
      
        it 'assigns order to @order' do
          assigns(:order).should_not be_nil
          assigns(:order).tour_id.should == @tour.id
        end
      end
      
      describe 'paid tour with explicitly passed tour_id' do
        it 'uses id from receipt' do
          @tour = FactoryGirl.create(:tour, :id => 45)
          @user = FactoryGirl.create(:user)

          post(
            :create,
              :order => {
                :receipt => receipt_from_ios,
                :tour_id => 15
              },
              :platform_id => 1,
              :format => :xml,
              :auth_token => @user.authentication_token
          )
          
          assigns(:order).tour_id.should == @tour.id
        end
      end
      
      describe 'get tour xml with explicitly passed tour_id and with paid ubertours receipt' do
        render_views

        it 'uses id from receipt' do
          @tour1 = FactoryGirl.create(:tour, :id => 43)
          @tour2 = FactoryGirl.create(:tour, :id => 44)
          @ubertour = FactoryGirl.create(:tour, :id => 45, :is_ubertour => true)
          TourUbertour.create! :tour_id => @tour1.id, :ubertour_id => @ubertour.id
          TourUbertour.create! :tour_id => @tour2.id, :ubertour_id => @ubertour.id

          @user = FactoryGirl.create(:user)

          post(
            :create,
              :order => {
                :receipt => receipt_from_ios,
              },
              :platform_id => 1,
              :format => :xml,
              :auth_token => @user.authentication_token
          )
          
          assigns(:order).tour_id.should == @ubertour.id
          Hash.from_xml(response.body)['order']['subtour'].count.should == 2
          Hash.from_xml(response.body)['order']['subtour'].collect{|subtour| subtour['id'].to_i} =~ [43, 44]
        end
      end

      describe 'free tour' do
        before do
          @tour = FactoryGirl.create(:tour, :id => 45, :free => true)
          @user = FactoryGirl.create(:user)

          post :create, :order => {:tour_id => 45}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
        end

        it 'responds with 201' do
          response.status.to_i.should == 201
        end
      
        it 'responds with Content-Type application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end
      
        it 'renders v1/ios/orders/create.xml' do
          response.should render_template('v1/ios/orders/create')
        end
      
        it 'creates new order' do
          @user.orders.ios.find_by_tour_id(@tour.id).should_not be_nil
        end
      
        it 'assigns order to @order' do
          assigns(:order).should_not be_nil
          assigns(:order).tour_id.should == @tour.id
        end
      end

      describe 'preview user buys his tour' do
        before do
          @client = FactoryGirl.create(:client)
          @tour = FactoryGirl.create(:tour, :id => 45, :free => false, :client_id => @client.id)
          #@user = Factory.create(:user, :is_preview_user => true)
          @user = @client.preview_user
          @client.tours << @tour
          @client.save
          @user.reset_authentication_token!

          post :create, :order => {:tour_id => 45}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
        end

        it 'responds with 201' do
          response.status.to_i.should == 201
        end
      
        it 'responds with Content-Type application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end
      
        it 'renders v1/ios/orders/create.xml' do
          response.should render_template('v1/ios/orders/create')
        end
      
        it 'creates new order' do
          @user.orders.ios.find_by_tour_id(@tour.id).should_not be_nil
        end
      
        it 'assigns order to @order' do
          assigns(:order).should_not be_nil
          assigns(:order).tour_id.should == @tour.id
        end
      end
    end

    # @TODO this test is invalid and it really doesn't test functionality
    describe 'ordering already ordered tour' do
      before do
        @tour = FactoryGirl.create(:tour, :id => 45)
        @user = FactoryGirl.create(:user)

        post :create, :order => {:receipt => receipt_from_ios}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
        @first_order = assigns(:order)
        post :create, :order => {:receipt => receipt_from_ios}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
      end
      
      it 'responds with 201' do
        response.status.to_i.should == 201
      end
      
      #it 'assigns to @order existing order' do
        #@first_order.should eq(assigns(:order))
      #end
    end
    
    describe "tour does not exist" do
      before do
        @user = FactoryGirl.create(:user)

        post :create, :order => {:receipt => receipt_from_ios}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
      end
      
      it 'responds with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "Tour id is invalid"
      end
    end
    
    describe "invalid receipt" do
      before do
        @tour = FactoryGirl.create(:tour, :id => 45)
        @user = FactoryGirl.create(:user)

        post :create, :order => {:receipt => receipt_encoded(@tour.id)}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
      end
      
      it "responds with 400" do
        response.status.to_i.should == 400
      end
      
      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "Receipt is invalid"
      end
    end
    
    describe "no platform_id provided" do
      before do
        @tour = FactoryGirl.create(:tour, :id => 45)
        @user = FactoryGirl.create(:user)

        post :create, :order => {:receipt => receipt_encoded(@tour.id)}, :format => :xml, :auth_token => @user.authentication_token
      end

      it "responds with 400" do
        response.status.to_i.should == 400
      end

      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "platform_id required"
      end

      after do
        ValidReceiptValidator.faraday_adapter = nil
      end
    end
    
    describe 'nor tour_id neither receipt provided' do
      before do
        @user = FactoryGirl.create(:user)

        post :create, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
      end
      
      it 'responds with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "Tour id is invalid"
      end
    end
    
    describe "unauthorized user" do
      it 'responds with 401' do
        # No need to ensure existance of tour, no action shoul be performed
        # as user is not authorized
        post :create, :order => {:receipt => receipt_encoded(1), :platform_id => 1}, :format => :xml

        response.status.to_i.should == 401
      end
    end
  end
end
