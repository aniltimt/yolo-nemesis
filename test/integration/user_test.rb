require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "registering user" do
    assert_equal 0, User.count

    assert_no_difference 'User.count' do
      post "/users", {:user => {:email => "example.com", :password => "1234567"}}
      assert_match /ERROR: Email is invalid/, response.body
      assert_response 401
    end

    assert_no_difference 'User.count' do
      post "/users", {:user => {:email => "valid@example.com", :password => "12345"}}
      assert_match /ERROR: Password is too short \(minimum is 6 characters\)/, response.body
      assert_response 401
    end

    assert_difference 'User.count', +1 do
      post "/users?user[email]=valid@example.com&user[password]=1234567"
      #assert_redirected_to :controller => "v1/users", :action => "return_token", :auth_token => User.last.authentication_token
      #follow_redirect!
      assert_match User.last.authentication_token, response.body
    end

    # clear session on server and logout
    request.reset_session
    delete destroy_user_session_path
    assert_response 401

    assert_no_difference 'User.count' do
      post "/users?user[email]=valid@example.com&user[password]=1234567"
      assert_match /ERROR: Email has already been taken/, response.body
      assert_response 401
    end

    assert_equal 1, User.count
  end

  test "the existing user get authorized" do
    assert_equal 0, User.count

    assert_difference 'User.count', +1 do 
      @user = User.create!(:email => "twit@example.com", :password => "123rt66")
    end

    post '/users/sign_in', {:user => {:email => "twit@example.com", :password => "123rt66"}}
    #assert_redirected_to :controller => "v1/users", :action => "return_token", :auth_token => User.last.authentication_token
    @user.reload
    assert @user.authentication_token
    #follow_redirect!
    assert_match @user.authentication_token, response.body

    # clear session on server and logout
    request.reset_session
    delete destroy_user_session_path
    assert_response 401

    get check_logged_in_url
    assert_response 401
    get check_logged_in_url, {:auth_token => @user.authentication_token}
    assert_response :success

    # truly log out by empying authentication_token
    authentication_token = @user.authentication_token
    @user.reset_authentication_token!
    @user.reload

    get check_logged_in_url, {:auth_token => authentication_token}
    assert_equal "ERROR: Unauthorized user", response.body
    assert_response 401
  end

  test "test the unauthorized user returns error while authorizing" do
    assert_equal 0, User.count
    post '/users/sign_in', {:user => {:email => "nonexists@example.com", :password => "nopassword"}}
    assert_redirected_to :controller => "v1/users", :action => "return_token"
    follow_redirect!
    assert_equal "ERROR: Unauthorized user", response.body
    assert_response 401
  end
end
