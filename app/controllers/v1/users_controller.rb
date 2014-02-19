class V1::UsersController < ApplicationController
  #before_filter :authenticate_user!, :only => [:check_logged_in]
  #skip_before_filter :authenticate_by_token!, :only => [:return_token]

  layout nil

  def return_token
    if current_user
      @user = current_user
      render :template => 'v1/registrations/create', :format => :xml, :layout => false, :status => 200
    else
      render :text => "ERROR: Unauthorized user", :layout => false, :status => 401
    end
  end

  def check_logged_in
    render :text => "LOGGED_IN", :layout => false
  end
end
