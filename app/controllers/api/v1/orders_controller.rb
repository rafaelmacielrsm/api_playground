class Api::V1::OrdersController < ApplicationController
  include JsonApiHelper

  before_action :authenticate_with_token!
  respond_to :json

  def index

    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders, status: :ok,
      meta: pagination(orders, params[:per_page])
  end

  def show
    json_api_show
  end

  def create
    order = current_user.orders.build(order_params)
    order.build_placements_with_product_ids_and_quantities(
      params[:order][:product_ids_and_quantities])
    json_api_create(order)
  end


  private
  def order_params
    params.require(:order).permit(:user_id).merge(
    product_ids: params[:order][:product_ids_and_quantities].map(&:first)
    )
  end
end
