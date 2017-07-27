class Product < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :user, presence: true

  # Scopes

  scope :filter_by_title, lambda {|keyword|
    where("lower(title) LIKE ?", "%#{keyword.downcase}%")
  }

  scope :above_or_equal_to_price, lambda {|price|
    where("products.price >= ?", price)
  }

  scope :below_or_equal_to_price, lambda {|price|
    where("products.price <= ?", price)
  }

  scope :recent, lambda { order(updated_at: :asc) }

  def self.search(params = {})
    if params[:product_ids].present?
      products = Product.find(params[:product_ids])
    else
      products = Product.all
    end

    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.above_or_equal_to_price(
      params[:min_price].to_f) if params[:min_price]
    # products = products.below_or_equal_to_price(
    #   params[:max_price].to_f) if params[:max_price]
    # products = products.recent if params[:recent].present?

    products
  end
end
