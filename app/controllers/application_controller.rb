class ApplicationController < ActionController::Base
  include Authenticable

  protect_from_forgery with: :null_session

  respond_to :json

  before_action :check_json_api_headers
  before_action :set_json_api_header



  protected
  def pagination(paginated_array, per_page)
    { pagination: {   per_page: per_page.to_i,
                      total_page: paginated_array.total_pages,
                      total_objects: paginated_array.count }}
  end

  def check_json_api_headers
    unless request.headers["Content-Type"] && request.headers["Content-Type"].
      include?("application/vnd.api+json")
        return render json: "", status: :unsupported_media_type
    end

    unless request.headers["Accept"] &&
      request.headers["Accept"].include?("application/vnd.api+json")
        return render json: "", status: :not_acceptable
    end
  end

  def set_json_api_header
    response.set_header("Content-Type", "application/vnd.api+json")
  end
end
