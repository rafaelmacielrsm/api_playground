class User < ApplicationRecord
  # callbacks
  before_create :generate_authentication_token!

  # Associations
  has_many :products, dependent: :destroy

  #model validations
  validates :auth_token, uniqueness: true

  # devises modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?( auth_token: auth_token )
  end
end
