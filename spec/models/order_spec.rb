require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :user_id }

  context 'validations' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :total }
    it { is_expected.to validate_numericality_of(:total).
      is_greater_than_or_equal_to(0)}
  end

  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :placements }
    it { is_expected.to have_many(:products).through(:placements) }    
  end
end
