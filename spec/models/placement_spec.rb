require 'rails_helper'

RSpec.describe Placement, type: :model do
  it { is_expected.to respond_to :order_id }
  it { is_expected.to respond_to :product_id }
  it { is_expected.to respond_to :quantity }

  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }

  describe '#decrement_product_quantity!' do
    let(:user) { FactoryGirl.build :user }
    let(:product) { FactoryGirl.build :product, quantity: 5 }
    let(:order) { FactoryGirl.build :order, user: user }
    let(:placement){
      FactoryGirl.build :placement, order: order, product: product}

    it 'should decrease the products quantity by the placement quantity' do
      expect { placement.decrement_product_quantity! }.
          to change{product.quantity}.by(- placement.quantity)
    end
  end
end
