class Api::V1::OrdersController < ApplicationController
  include JsonApiHelper

  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with current_user.orders
  end

  def show
    json_api_show
  end
end
