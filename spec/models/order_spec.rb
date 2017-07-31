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

  describe '#build_placements_with_product_ids_and_quantities' do
    let(:product1) { FactoryGirl.create :product, price: 100, quantity: 5 }
    let(:product2) { FactoryGirl.create :product, price: 85, quantity: 10 }
    let(:product_quantity_array) { [ [product1.id, 2], [product2.id, 3] ] }

    it do
      allow(subject).to receive(:build)
      expect{ subject.build_placements_with_product_ids_and_quantities(
        product_quantity_array) }.to change{ subject.placements.length }.by(2)
    end
  end

  describe "#valid?" do
    before do
      product1 = FactoryGirl.create :product, price: 100, quantity: 5
      product2 = FactoryGirl.create :product, price: 85, quantity: 10

      placement1 = FactoryGirl.build :placement, product: product1, quantity: 3
      placement2 = FactoryGirl.build :placement, product: product2, quantity: 15

      @order = FactoryGirl.build :order
      @order.placements << placement1
      @order.placements << placement2
    end

    it 'should be invalid due to insufficient products' do
      expect( @order ).not_to be_valid
    end
  end
end
