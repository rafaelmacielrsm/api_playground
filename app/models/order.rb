class Order < ApplicationRecord
  before_validation :set_total!

  # Associations
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  # Validations
  validates :user_id, presence: true
  validates_with EnoughProductsValidator

  def set_total!
    self.total = 0
    placements.each do |placement|
      self.total += placement.product.price * placement.quantity
    end
  end

  def build_placements_with_product_ids_and_quantities(product_quantity_array)
    product_quantity_array.each do |data|
      id, quantity = data
      self.placements.build(product_id: id, quantity: quantity)
    end
  end
end
