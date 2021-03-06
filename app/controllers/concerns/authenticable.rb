module Authenticable
 extend ActiveSupport::Concern
  # Override current_user method used in the devise gem
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    render  json: "null",
            status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end
end
