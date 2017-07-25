class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def show
    respond_with( Product.find(params[:id]) )
  end

  def index
    respond_with Product.all
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: :created, location: [:api, product]
    else
      render( json: {errors: product.errors }.to_json,
              status: :unprocessable_entity)
    end
  end

  def update
    product = current_user.products.find(params[:id])
    if product.update_attributes(product_params)
      render json: product, status: :ok, location: [:api, product]
    else
      render(
        json: {errors: product.errors}.to_json,
        status: :unprocessable_entity)
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
    head :no_content
  end

  private
  def product_params
    params.require(:product).permit([:title, :price, :published])
  end
end