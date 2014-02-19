class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_by_token!

  before_filter :miniprofiler, :if => lambda { ! Rails.env.production? }

  def after_sign_in_path_for(resource)
    current_user.reset_authentication_token!
    users_return_token_path(:auth_token => current_user.authentication_token)
  end

  def authenticate_by_token!
    reset_session
    if !params[:auth_token].blank?
      if user = User.find_by_authentication_token(params[:auth_token])
        return true
      else
        render :text => "ERROR: Unauthorized user", :layout => false, :status => 401
      end
    else
      render :text => "ERROR: Unauthorized user", :layout => false, :status => 401
    end
  end

  private

    def miniprofiler
      Rack::MiniProfiler.authorize_request # if user.admin?
    end

    def bad_request(reason)
      error_response(reason, 400)
    end
    
    def error_response(reason, code)
      respond_to do |format|
        format.xml {render :xml => {:error => reason}, :status => code}
      end
    end
end
