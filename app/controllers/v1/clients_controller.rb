class V1::ClientsController < ApplicationController
  skip_before_filter :authenticate_by_token!
  before_filter :request_auth

  def index
    @clients = Client.all
    respond_to do |format|
      format.js { render :json => @clients.to_json }
    end
  end

  private
  def request_auth
    authenticate_or_request_with_http_basic do |login, passwd|
      login == TB_SYNC_LOGIN && passwd == TB_SYNC_PASSWD
    end
  end
end
