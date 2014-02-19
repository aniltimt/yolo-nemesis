class V1::PlacesController < ApplicationController
  skip_before_filter :authenticate_by_token!

  def index
    unless params[:platform_id].present?
      bad_request("platform_id required")
      return
    end

    if params[:auth_token]
      @user = User.find_by_authentication_token(params[:auth_token])
    end

    @is_android = false
    if params[:platform_type] == 'android'
      @is_android = true
    end

    if params[:api_key].blank?
      if @user && @user.is_preview_user

        # admin's preview user 
        client_id_or_nil = case @user.email
        when 'aminiailo@cogniance.com'; nil
        when 'waldmanjulie@gmail.com'; nil
        else
          @user.client.id
        end

        @places = Tour.where(:client_id => client_id_or_nil).all
      else
        @places = Tour.where('client_id IS NULL')
        if @is_android
          @places = @places.where('is_published = 1')
        end
      end
    else
      client = Client.find_by_api_key(params[:api_key])
      if client
        @places = client.tours
        if @is_android
          @places = client.tours.where('is_published = 1')
        end
      else
        bad_request("no client with provided api_key found")
        return
      end
    end

    respond_to do |format|
      format.xml { render }
    end
  end
end
