#require 'test_helper'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'test_helper')

class V1::SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "facebook login" do
    #get '/login'
    #assert_match /facebook/, response.body
    
    # provider: facebook
    # uid: '1237193556'
    # credentials:
    #   token: BBBCXDbRjwoIBAE580y1QUOfwYjVKPaYYGZCPSMJkNvAIF25oABywZc0PnflWd3eSLZAIHtlIpbvbPEhVUNsZCAz4464utIZD
    # user_info:
    #   nickname: germaninthetown
    #   email: valid@example.com
    #   first_name: Dmitrii
    #   last_name: Samoilov
    #   name: Dmitrii Samoilov

    assert !OauthUser.find_by_provider_and_uid("facebook", "1234567890")

    # simulate omniauth response
    assert_difference ['User.count', 'OauthUser.count'], +1 do
      request.env["omniauth.auth"] = {"provider" => "facebook", "uid" => "1234567890", "credentials" => {"token" => "BBBCXDbRjwoIBAE580y1QUOfwYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD"}, "user_info" => {:nickname => "germaninthetown", "email" => "valid@example.com", "first_name" => "Dmitrii", "last_name" => "Samoilov", "name" => "Dmitrii Samoilov"}}
      post :create
    end

    @oauthuser = OauthUser.last
    @user = User.last
    assert_equal 'valid@example.com', @oauthuser.email
    assert_equal 'valid@example.com', @user.email

    assert_equal 'facebook', @oauthuser.provider
    assert_equal '1234567890', @oauthuser.uid
    assert_equal 'BBBCXDbRjwoIBAE580y1QUOfwYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD', @oauthuser.oauth_token
    
    assert_equal 'Dmitrii', @oauthuser.first_name
    assert_equal 'Samoilov', @oauthuser.last_name
    assert_equal 'Dmitrii Samoilov', @oauthuser.name

    assert_equal 'Dmitrii', @user.first_name
    assert_equal 'Samoilov', @user.last_name
    assert_equal 'Dmitrii Samoilov', @user.name

    assert !@user.oauth_users.empty?
    assert_equal @oauthuser.id, @user.oauth_users.first.id

    @user.reload
    assert @user.authentication_token
  end

  test "twitter login" do
    #get '/login'
    #assert_match /twitter/, response.body
    
    # provider: twitter
    # uid: '20855663'
    # credentials:
    #   token: BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD
    # user_info:
    #   nickname: germaninthetown
    #   name: Dmitri Samoilov

    twitter_response = {"provider" => "twitter", "uid" => "20855663", "credentials" => {"token" => "BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD"}, "user_info" => {"nickname" => "germaninthetown", "name" => "Dmitrii Samoilov"}}

    assert !OauthUser.find_by_provider_and_uid("facebook", "1234567890")

    # simulate omniauth response
    assert_difference ['User.count', 'OauthUser.count'], +1 do
      request.env["omniauth.auth"] = twitter_response
      post :create
    end

    @oauthuser = OauthUser.last
    @user = User.last
    assert_equal '', @oauthuser.email
    assert_equal '', @user.email

    assert_equal 'twitter', @oauthuser.provider
    assert_equal '20855663', @oauthuser.uid
    assert_equal 'BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD', @oauthuser.oauth_token
    
    assert_equal 'Dmitrii Samoilov', @oauthuser.name
    assert_equal 'Dmitrii Samoilov', @user.name

    assert !@user.oauth_users.empty?
    assert_equal @oauthuser.id, @user.oauth_users.first.id

    @user.reload
    assert @user.authentication_token
  end

  test "2 users sequentially login via twitter" do
    # first user
    assert !OauthUser.find_by_provider_and_uid("twitter", "20855663")

    # simulate omniauth response
    assert_difference ['User.count', 'OauthUser.count'], +1 do
      request.env["omniauth.auth"] = {"provider" => "twitter", "uid" => "20855663", "credentials" => {"token" => "BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD"}, "user_info" => {"nickname" => "germaninthetown", "name" => "Dmitrii Samoilov"}}
      post :create
    end

    @oauthuser = OauthUser.last
    @user = User.last
    assert_equal '', @oauthuser.email
    assert_equal '', @user.email

    assert_equal 'twitter', @oauthuser.provider
    assert_equal '20855663', @oauthuser.uid
    assert_equal 'BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35oABywUc0PnflWd3eSLZAIftlIpbvbPEhVUNsZCAz4464utIZD', @oauthuser.oauth_token
    
    assert_equal 'Dmitrii Samoilov', @oauthuser.name
    assert_equal 'Dmitrii Samoilov', @user.name

    assert !@user.oauth_users.empty?
    assert_equal @oauthuser.id, @user.oauth_users.first.id

    @user.reload
    assert @user.authentication_token


    # second user logs in
    assert !OauthUser.find_by_provider_and_uid("twitter", "373977493")

    # simulate omniauth response
    assert_difference ['User.count', 'OauthUser.count'], +1 do
      request.env["omniauth.auth"] = {"provider" => "twitter", "uid" => "373977493", "credentials" => {"token" => "BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35dfgsde563rRGSDFGew5tftlIpbvbPEhVUNsZCAz4464utIZD"}, "user_info" => {"nickname" => "EugeneBelyakov", "name" => "Eugene Belyakov"}}
      post :create
    end

    @oauthuser = OauthUser.last
    @user = User.last
    
    # check whether index for empty email (along with record) was created  
    assert_equal '', @oauthuser.email
    assert_equal '', @user.email

    assert_equal 'twitter', @oauthuser.provider
    assert_equal '373977493', @oauthuser.uid
    assert_equal 'BBBCXDbRjwoIBAE58wYjVKPaIYGZCRSMJkNvAIF35dfgsde563rRGSDFGew5tftlIpbvbPEhVUNsZCAz4464utIZD', @oauthuser.oauth_token
    
    assert_equal 'Eugene Belyakov', @oauthuser.name
    assert_equal 'Eugene Belyakov', @user.name

    assert !@user.oauth_users.empty?
    assert_equal @oauthuser.id, @user.oauth_users.first.id

    @user.reload
    assert @user.authentication_token
  end

  test "merge login and twitter accounts" do
  end
end
