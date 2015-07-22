class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    auth = request.env["omniauth.auth"]
    identity = Identity.find_for_oauth(auth)
    user = identity.user
    if user
      if user.confirmed?
        user.update_attributes(twitter_token: auth.credentials.token, twitter_secret: auth.credentials.secret)
        redirect_to "http://localhost:3001/auth/twitter/callback?token=#{auth.credentials.token}"
      else
        redirect_to "http://localhost:3001/finish_sign_up?token=#{auth.credentials.token}&first_name=#{user.first_name}&last_name=#{user.last_name}"
      end
    else
      User.find_for_oauth(auth, identity)
      redirect_to "http://localhost:3001/finish_sign_up?token=#{auth.credentials.token}"
    end
  end
end
