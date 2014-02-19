xml.instruct!
xml.auth do |auth|
  auth.provider 'market_api'
  auth.username @user.email
  auth.token @user.authentication_token
end
