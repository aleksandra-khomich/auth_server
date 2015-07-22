class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable,
         :validatable, :omniauthable, :omniauth_providers => [:twitter]

  has_one :identity, dependent: :destroy

  attr_accessor :twitter_login

  validates :first_name, :last_name, presence: true, unless: :twitter_login

  TEMP_EMAIL_PREFIX = 'change@me'

  class << self
    def find_for_oauth(auth, identity)
      user = User.create_user(auth)
      associate_identity(identity, user)
      user
    end

    def create_user(auth)
      user = User.new(
          email: temp_email(auth),
          password: Devise.friendly_token[0, 20],
          twitter_token: auth.credentials.token,
          twitter_secret: auth.credentials.secret,
          twitter_login: true,
          token: generate_token
      )
      user.skip_confirmation!
      user.save!
      user.update_attributes(confirmed_at: nil)
      user
    end

    def temp_email(auth)
      "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
    end

    def associate_identity(identity, user)
      identity.user = user
      identity.save!
    end

    def generate_token
      Digest::SHA1.hexdigest([Time.now, rand].join)
    end
  end
end
