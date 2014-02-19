class Admin::ApplicationController < ApplicationController
 skip_before_filter :authenticate_by_token!
  layout 'admin/application'
 # before_filter :request_auth

  private
  def request_auth
    if !admin_logged_in?
      redirect_to new_admin_login_path
    end
  end

  def admin_logged_in?
    !!session[:_admin_logged_in]
  end
end
