class UsersController < ApplicationController
  respond_to :json

  def login_with_twitter
    redirect_to user_omniauth_authorize_path(:twitter)
  end

  def me
    @user = find_user
    respond_with @user.as_json
  end

  def update
    @user = find_user
    if @user.update_attributes(users_params)
      render status: 200, json: { message: success_message }
    else
      render status: 422, json: { errors: @user.errors }
    end
  end

  def create
    @user = User.new(users_params)
    if @user.save
      render status: 200, json: { message: success_message }
    else
      render status: 422, json: { errors: @user.errors }
    end
  end

  def confirm_email
    @user = User.find_by_confirmation_token Devise.token_generator.digest(self, :confirmation_token, params[:token])
    @user.confirm
    render json: { status: 200 }
  end

  private

  def success_message
    users_params.include? :email ? "Confirmation instructions were sent to #{@user.unconfirmed_email}." : "User was successfully updated."
  end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def find_user
    doorkeeper_token.nil? ? User.where(twitter_token: params[:token]).first : User.find(doorkeeper_token.resource_owner_id)
  end
end
