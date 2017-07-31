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

  def create
    order = current_user.orders.build(order_params)
    json_api_create(order)
  end


  private
  def order_params
    params.require(:order).permit(:user_id, :total, :product_ids => [])
  end
end
