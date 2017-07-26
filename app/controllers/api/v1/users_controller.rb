class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json


  def show
    user = User.find_by_id(params[:id])
    if user
      render json: user, status: :ok, location: [:api, user]
    else
      render json: "null", status: :not_found
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render(
        json: user,
        status: :created,
        location: [:api, user]
      )
    else
      render(
        json: {errors: user.errors}.to_json,
        status: :unprocessable_entity
      )
    end
  end

  def update
    user = User.find_by_id(params[:id])
    unless current_user && current_user.eql?(user)
      return render json: "null", status: :not_found
    end
    if user.update_attributes(user_params)
      render  json: user,
              status: :ok,
              location: [:api, user]
    else
      render  json: {errors: user.errors }.to_json,
              status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head :no_content
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
