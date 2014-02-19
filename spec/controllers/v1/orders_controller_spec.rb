require 'spec_helper'

describe V1::OrdersController do
  describe 'GET /v1/orders.xml' do
    describe 'authorized user' do
      describe 'when no orders exist' do
        before do
          @user = FactoryGirl.create(:user)

          get :index, :format => :xml, :platform_id => 1, :auth_token => @user.authentication_token
        end

        it 'responds with 200' do
          response.status.to_i.should == 200
        end
    
        it 'responds with application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end
    
        it 'assigns empty array to @orders' do
          assigns(:orders).should be_empty
        end
      end
  
      describe 'when there are orders' do
        before do
          @user = FactoryGirl.create(:user)
      
          10.times { @user.orders << FactoryGirl.create(:order) }

          get :index, :format => :xml, :platform_id => 1, :auth_token => @user.authentication_token
        end

        it 'responds with 200' do
          response.status.to_i.should == 200
        end
    
        it 'responds with application/xml' do
          response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
        end
    
        it 'assigns array of orders to @orders' do
          assigns(:orders).should_not be_empty
          assigns(:orders).should have(10).items
        end
      end
    end
    
    describe 'no platform_id provided' do
      before do
        @user = FactoryGirl.create(:user)

        get :index, :format => :xml, :auth_token => @user.authentication_token
      end

      it 'responds with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error message' do
        Hash.from_xml(response.body)['hash']['error'].should == "platform_id required"
      end
    end
    
    describe 'unauthorized user' do
      it 'responds with 401' do
        get :index, :format => :xml

        response.status.to_i.should == 401
      end
    end
  end
end
