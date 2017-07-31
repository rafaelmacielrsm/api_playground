require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :user_id }

  context 'validations' do
    it { is_expected.to validate_presence_of :user_id }
  end

  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :placements }
    it { is_expected.to have_many(:products).through(:placements) }
  end

  describe '#set_total' do
    let(:product1) { FactoryGirl.create :product, price: 100 }
    let(:product2) { FactoryGirl.create :product, price: 85 }
    let(:order){
      FactoryGirl.build :order, product_ids: [product1.id, product2.id] }

    it { expect{ order.set_total! }.to change{order.total}.from(0).to(185) }
  end
end
