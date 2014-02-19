class V1::SessionsController < ApplicationController

  skip_before_filter :authenticate_by_token!, :only => [:create]

  def create
    @auth = request.env["omniauth.auth"]
    #Rails.logger.warn 'auth.to_yaml - ' + @auth.to_yaml
    oauth_user = OauthUser.find_by_provider_and_uid(@auth["provider"], @auth["uid"])
    #Rails.logger.warn 'oauth_user - ' + oauth_user.inspect
    @user = oauth_user ? oauth_user.user : OauthUser.create_with_omniauth(@auth)

    sign_in(:user, @user, :event => :authentication)
    @user.reset_authentication_token! if @user.authentication_token.nil?
    sign_out
    reset_session
  end

  def destroy  
    reset_session
    redirect_to root_url, :notice => t("signed_out")
  end
end
