class Order < ApplicationRecord
  before_validation :set_total!

  # Associations
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  # Validations
  validates :user_id, presence: true

  def set_total!
    self.total = self.products.map(&:price).sum
  end
end
