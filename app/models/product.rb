class Product < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :user, presence: true
end
