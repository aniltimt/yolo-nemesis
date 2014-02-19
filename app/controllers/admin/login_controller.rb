class Admin::LoginController < ActionController::Base #ApplicationController
  #skip_before_filter :request_auth, :onl

  def new
  end

  def create
    require 'digest'
    @login = params[:login]
    @password = params[:password]

    admin = Admin.first
    raise "There is no admin in the database" if !admin

    if @login == admin.login && Devise::Encryptors::Sha1.digest(@password, 10, admin.salt, '') == admin.password
      session[:_admin_logged_in] = true
      redirect_to root_path
    else
      flash[:alert] = "Invalid login or password."
      render :action => "new"
    end
  end

  def change
    admin = Admin.first
    raise "There is no admin in the database" if !admin

    encrypted_password = params[:password]
    salt               = params[:salt]

    if params[:prev_password] == admin.password
      admin.password = params[:password]
      admin.salt     = params[:salt]
      if admin.save(:validate => false)
        render :text => "OK", :layout => false, :status => 200
      else
        render :text => "error", :layout => false, :status => 401
      end
    else
      render :text => "error", :layout => false, :status => 401
    end
  end

  def destroy
    session[:_admin_logged_in] = nil
    redirect_to root_path
  end
end
