class Client < ActiveRecord::Base
  validates_presence_of :name, :email
  validates_uniqueness_of :email, :name
  validates_length_of :password, :minimum => 6, :on => :update
  validates :email, :exclusion => {:in => MarketApi::Application.config.reserved_emails,  :message => "%{value} is reserved"}

  has_many :tours
  has_many :users

  attr_accessor :merge_existing_user

  before_create :generate_api_key_and_password
  after_create :create_user_with_preview_rights
  before_create :check_if_user_with_the_same_email_present

  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/

  validates_format_of :email, :with => EMAIL_PATTERN

  def generated_users
    self.users.where(:is_preview_user => false)
  end

  def preview_user
    self.users.where(:is_preview_user => true).first
  end

  def generate_api_key_and_password
    password_symbols = (["A".."Z", "a".."z", 1..9].map(&:to_a).flatten + ['!','$'])
    self.api_key = Devise.friendly_token[0,20]
    self.password = password_symbols.sample(7).join
  end

  def check_if_user_with_the_same_email_present
    if User.find_by_email(self.email) && ! self.merge_existing_user
      self.errors.add :user_email_conflict, "You are registering client with email which is belong to user. Do you want merge accounts and reset user's password?"
      false
    else
      true
    end
  end

  def create_user_with_preview_rights
    self.reload

    user = if self.merge_existing_user
      u = User.find_by_email self.email
      u.update_attributes :password => self.password, :is_preview_user => true
      u.reload
      u
    else
      User.create!(:email => self.email, :password => self.password, :is_preview_user => true)
    end

    self.users << user
  end
end
