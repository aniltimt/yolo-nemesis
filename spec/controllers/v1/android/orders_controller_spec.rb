require 'spec_helper'

describe V1::Android::OrdersController do
  describe 'POST /v1/android/orders.xml' do
    describe 'successful case' do
      describe 'paid tour' do
        before do
          @tour = FactoryGirl.create(:tour, :id => 45)
          @user = FactoryGirl.create(:user)

          receipt = android_receipt(["com.abc." << @tour.id.to_s]).to_json
          signature = sign_android_receipt receipt
          post :create, :order => {:receipt => receipt, :signature => signature}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
        end

        it 'responds with 201' do
          response.status.to_i.should == 201
        end

        it 'responds with Content-Type application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end

        it 'renders v1/android/orders/create.xml' do
          response.should render_template('v1/android/orders/create')
        end

        it 'creates new order' do
          @user.orders.find_by_tour_id(@tour.id).should_not be_nil
        end
      end
      
      describe 'free tour' do
        before do
          @tour = FactoryGirl.create(:tour, :id => 45, :free => true)
          @user = FactoryGirl.create(:user)

          post :create, :order => {:tour_id => @tour.id}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
        end

        it 'responds with 201' do
          response.status.to_i.should == 201
        end

        it 'responds with Content-Type application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end

        it 'renders v1/ios/orders/create.xml' do
          response.should render_template('v1/android/orders/create')
        end

        it 'creates new order' do
          @user.orders.find_by_tour_id(@tour.id).should_not be_nil
        end
      end
    end

    describe "tour does not exist" do
      before do
        @user = FactoryGirl.create(:user)

        receipt = android_receipt(["com.abc.1"]).to_json
        signature = sign_android_receipt receipt
        post :create, :order => {:receipt => receipt, :signature => signature}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
      end
      
      it 'responds with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "Tour id is invalid"
      end
    end

    describe 'invalid receipt/signature' do
      before do
        @tour = FactoryGirl.create(:tour, :id => 45)
        @user = FactoryGirl.create(:user)

        receipt = android_receipt(["com.abc." << @tour.id.to_s]).to_json
        signature = 'invalid signature'
        post :create, :order => {:receipt => receipt, :signature => signature}, :platform_id => 1, :format => :xml, :auth_token => @user.authentication_token
      end

      it 'responds with 400 code' do
        response.status.to_i.should == 400
      end
      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "Receipt is invalid"
      end
    end
  end
end
