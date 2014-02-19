require 'spec_helper'

describe V1::PlacesController do
=begin
  describe 'GET /v1/places.xml?platform_id=:platform_id&api_key=:api_key' do
    describe 'successful case' do
      before do
        @client = Factory.create(:client)
        @tours = 5.times.map { Factory.create(:tour, :client => @client) }
        get :index, :format => :xml, :platform_id => 1, :api_key => @client.api_key
      end

      it 'responds with 200' do
        response.status.to_i.should == 200
      end
    
      it 'responds with application/xml' do
        response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
      end
    
      it 'renders v1/places/index template' do
        response.should render_template('v1/places/index')
      end
    
      it 'assigns tours to @places' do
        assigns(:places).should == @tours
      end
    end

    describe 'api_key didn\'t match any client' do
      before do
        get :index, :format => :xml, :platform_id => 1, :api_key => 'not_existing_api_key'
      end
      
      it 'should respond with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error description' do
        Hash.from_xml(response.body)['hash']['error'].should == "no client with provided api_key found"
      end
    end

    describe 'platform_id is missing' do
      before do
        get :index, :format => :xml
      end
      
      it 'should respond with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error description' do
        Hash.from_xml(response.body)['hash']['error'].should == "platform_id required"
      end
    end
  end

  describe 'GET /v1/places.xml?platform_id=:platform_id' do
    describe 'successful case' do
      before do
        @tours = 5.times.map { Factory.create(:tour, :client_id => nil) }
        #Tour.stub(:all).and_return(@tours)
        get :index, :format => :xml, :platform_id => 1
      end

      it 'responds with 200' do
        response.status.to_i.should == 200
      end
    
      it 'responds with application/xml' do
        response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
      end
    
      it 'renders v1/places/index template' do
        response.should render_template('v1/places/index')
      end
    
      it 'assigns tours to @places' do
        assigns(:places).should == @tours
      end
    end
    
    describe 'platform_id is missing' do
      before do
        get :index, :format => :xml
      end
      
      it 'should respond with 400' do
        response.status.to_i.should == 400
      end
      
      it 'contains error description' do
        Hash.from_xml(response.body)['hash']['error'].should == "platform_id required"
      end
    end
  end
=end
  describe "login as client's preview user (using his auth token)" do
    before do
      # create client
      @client = FactoryGirl.create(:client)
      # create related tours (only published are present)
      @tours = (0..10).map{ FactoryGirl.create(:tour, :client => @client) }
      @unrelated_tour = FactoryGirl.create(:tour)
      @user = @client.users.last
      @user.reset_authentication_token!
      @user.reload
      get :index, :format => :xml, :platform_id => 1, :auth_token => @user.authentication_token
    end

    it 'responds with 200' do
      response.status.to_i.should == 200
    end

    it 'responds with application/xml' do
      response.headers['Content-Type'].should == 'application/xml; charset=utf-8'
    end
    
    it 'renders v1/places/index template' do
      response.should render_template('v1/places/index')
    end
    
    it 'assigns tours to @places' do
      assigns(:places).should == @tours
    end

    it "returns no unrelated tours" do
      assigns(:places).should_not include(@unrelated_tour)
    end
  end

  describe "login as client's preview user (w/o his auth token)" do
    before do
      # create admin's tours
      @tours = (0..10).map{ FactoryGirl.create(:tour, :client => nil) }
      get :index, :format => :xml, :platform_id => 1
    end

    it 'responds with 200' do
      response.status.to_i.should == 200
    end

    it 'responds with application/xml' do
      response.headers['Content-Type'].should == "application/xml; charset=utf-8"
    end
    
    it 'assigns all published available tours to @places' do
      assigns(:places).should == @tours
    end
  end

  describe "android platform and admin published tours" do
    before do
      # create admin's tours
      @tours = (0..10).map{ FactoryGirl.create(:tour, :client => nil, :is_published => true) }
      get :index, :format => :xml, :platform_id => 1, :platform_type => "android"
    end

    it 'responds with 200' do
      response.status.to_i.should == 200
    end

    it 'responds with application/xml' do
      response.headers['Content-Type'].should == "application/xml; charset=utf-8"
    end
    
    it 'assigns all published available tours to @places' do
      assigns(:places).should == @tours
    end
  end

  describe "android platform and client published tours" do
    before do
      @client = FactoryGirl.create(:client)
      # create related tours (only published are present)
      @tours = (0..10).map{ FactoryGirl.create(:tour, :client => @client, :is_published => true) }
      @unrelated_tour = FactoryGirl.create(:tour)
      @user = @client.users.last
      @user.reset_authentication_token!
      @user.reload
      get :index, :format => :xml, :platform_id => 1, :auth_token => @user.authentication_token, :platform_type => 'android'
    end

    it 'responds with 200' do
      response.status.to_i.should == 200
    end

    it 'responds with application/xml' do
      response.headers['Content-Type'].should == "application/xml; charset=utf-8"
    end
    
    it 'assigns all published available tours to @places' do
      assigns(:places).should == @tours
    end
  end

  describe "android platform and client UNpublished tours" do
    before do
      @client = FactoryGirl.create(:client)
      @tours = (0..10).map{ FactoryGirl.create(:tour, :client => @client, :is_published => false) }
      @unrelated_tour = FactoryGirl.create(:tour)
      #@user = @client.users.last
      @user = FactoryGirl.create(:user, :email => 'email@example.com', :password => 'password', :is_preview_user => 0,  :client_id => @client.id)
      @user.reset_authentication_token!
      @user.reload
      get :index, :format => :xml, :platform_id => 1, :auth_token => @user.authentication_token, :platform_type => 'android'
    end

    it 'responds with 200' do
      response.status.to_i.should == 200
    end

    it 'responds with application/xml' do
      response.headers['Content-Type'].should == "application/xml; charset=utf-8"
    end
    
    it 'assigns all published available tours to @places' do
      assigns(:places).should == []
    end
  end

  describe "android platform and client UNpublished tours for preview user" do
    before do
      @client = FactoryGirl.create(:client)
      @tours = (0..10).map{ FactoryGirl.create(:tour, :client => @client, :is_published => false) }
      @unrelated_tour = FactoryGirl.create(:tour)
      @user = @client.users.last
      @user.reset_authentication_token!
      @user.reload
      get :index, :format => :xml, :platform_id => 1, :auth_token => @user.authentication_token, :platform_type => 'android'
    end

    it 'responds with 200' do
      response.status.to_i.should == 200
    end

    it 'responds with application/xml' do
      response.headers['Content-Type'].should == "application/xml; charset=utf-8"
    end
    
    it 'assigns all published available tours to @places' do
      assigns(:places).should == @tours
    end
  end
end
