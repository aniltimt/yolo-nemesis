xml.instruct!
xml.auth do |auth|
  auth.provider @auth['provider']
  auth.username @auth['user_info']['name']
  auth.token @user.authentication_token
end
