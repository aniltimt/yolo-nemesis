require 'spec_helper'

describe V1::ClientsController do
  describe 'GET /v1/clients.js' do
    describe 'successful case' do
      before do
        @clients = 5.times.map { |i| FactoryGirl.build(:client, :id => i) }
        Client.stub(:all).and_return(@clients)
        @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(TB_SYNC_LOGIN, TB_SYNC_PASSWD)

        get :index, :format => :js
      end

      it 'responds with 200' do
        response.status.to_i.should == 200
      end
    
      it 'responds with application/xml' do
        response.headers['Content-Type'].should == 'text/javascript; charset=utf-8'
      end
    
      #it 'renders v1/places/index template' do
      #  response.should render_template('v1/places/index')
      #end
    
      it 'assigns clients to @clients' do
        assigns(:clients).should == @clients
      end
    end
  end
end
