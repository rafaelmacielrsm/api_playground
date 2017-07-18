class Api::V1::SessionsController < ApplicationController
  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user.valid_password? user_password
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: :ok, location: [:api, user]
    else
      render json: {
        errors: I18n.t('devise.failure.invalid', authentication_keys: 'User')},
        status: :unprocessable_entity
    end
  end
end
