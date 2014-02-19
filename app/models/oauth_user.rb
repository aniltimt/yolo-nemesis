class OauthUser < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :provider, :uid

  def self.create_with_omniauth(auth)
    oauth_user = self.new
    user = User.new

    oauth_user.provider = auth['provider']  
    oauth_user.uid = auth['uid']

    if auth['user_info']
      oauth_user.name = auth['user_info']['name']
      user.name       = auth['user_info']['name']

      oauth_user.nickname = auth['user_info']["nickname"]
      oauth_user.email = auth['user_info']['email'].to_s
      user.email       = auth['user_info']['email'].to_s

      oauth_user.first_name = auth['user_info']['first_name']
      user.first_name = auth['user_info']['first_name']

      oauth_user.last_name = auth['user_info']['last_name']
      user.last_name       = auth['user_info']['last_name']
    end

    if auth['credentials'] && auth['credentials']['token']
      oauth_user.oauth_token = auth['credentials']['token']
    end

    oauth_user.save

    user.password = Devise.friendly_token[0,20]
    user.save

    user.oauth_users << oauth_user
    user
  end
end
