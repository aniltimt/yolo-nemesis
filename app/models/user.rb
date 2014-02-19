class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :is_preview_user
  
  has_many :tours
  has_many :orders
  has_many :oauth_users

  belongs_to :client

  scope :top_buyers, lambda { |*args| where('orders_count > 0').order('orders_count DESC').limit(args.blank? ? nil : args.pop) }
  scope :registered, lambda { where('client_id IS NULL') }
  scope :generated, lambda { where('client_id IS NOT NULL') }
  scope :generation, lambda { |generation_index| where(:generation_index => generation_index) }
  scope :without_preview, lambda { where(:is_preview_user => false) }

  class << self
    def registrations_by_year
      select('id, created_at').
      group('DATE_FORMAT(created_at, "%Y")').
      order('created_at ASC').
      count('id').to_a
    end

    def registrations_by_month
      select('id, created_at').
      group('DATE_FORMAT(created_at, "%b")').
      order('created_at ASC').
      count('id').to_a
    end
  end

  def name_or_email
    ! self.email.blank? ? self.email : self.oauth_users.map{|ou| ou.nickname}.join(', ')
  end
end
