require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { FactoryGirl.build :product }

  it { expect(subject).to respond_to(:title) }
  it { expect(subject).to respond_to(:price) }
  it { expect(subject).to respond_to(:published) }
  it { expect(subject).to respond_to(:user_id) }

  context 'validations' do
    it { expect(subject).to validate_presence_of(:title) }
    it { expect(subject).to validate_presence_of(:price) }
    it {
      expect(subject).to validate_numericality_of(:price)
        .is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_presence_of(:user) }
  end

  context 'associations' do
    it { expect(subject).to belong_to(:user) }
  end

  describe ".filter_by_title" do
    before do
      @product1 = FactoryGirl.create :product, title: "A plasma TV"
      @product2 = FactoryGirl.create :product, title: "Fastest Laptop"
      @product3 = FactoryGirl.create :product, title: "CD player"
      @product4 = FactoryGirl.create :product, title: "LCD TV"
    end

    context "When a 'TV' title pattern is sent" do
      it 'should return the 2 products that matches the pattern' do
        expect(Product.filter_by_title("TV")).to have(2).items
      end

      it 'should returns the products matching' do
        expect(Product.filter_by_title("TV")).
          to match_array([@product1, @product4])
      end
    end
  end

  describe ".above_or_equal_to_price" do
    before do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end

    it 'should return products which are above or equal to the price' do
      expect(Product.above_or_equal_to_price(100)).
        to match_array([@product1, @product3])
    end
  end

  describe ".below_or_equal_to_price" do
    before do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end

    it 'should return products which are below or equal to the price' do
      expect(Product.below_or_equal_to_price(100)).
        to match_array([@product2, @product1, @product4])
    end
  end

  describe ".recent" do
    before do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99

      @product3.touch
      @product2.touch
    end

    it "return the most updated records" do
      expect(Product.recent).
        to eq([@product1, @product4, @product3, @product2])
    end
  end

  describe ".search" do
    before do
      @product1 = FactoryGirl.create :product, price: 100, title: "Plasma TV"
      @product2 = FactoryGirl.create :product, price: 50, title: "Videogame"
      @product3 = FactoryGirl.create :product, price: 150, title: "MP3"
      @product4 = FactoryGirl.create :product, price: 99, title: "Laptop"
    end

    context "when title 'videogame' and '100' minimum price are set" do
      it "should return an empty array" do
        search_hash = {keyword: 'videogame', min_price: 100}
        expect(Product.search search_hash).to eq([])
      end
    end

    context "when title 'tv', 50 min price and 150 max_price are set" do
      it "should return a matching product" do
        search_hash = {keyword: 'tv', min_price: 50, max_price: 150}
        expect(Product.search search_hash).to contain_exactly(@product1)
      end
    end

    context "when a empty hash is sent" do
      it "should return all products" do
        expect(Product.search {}).
          to contain_exactly(@product1, @product2, @product3, @product4)
      end
    end

    context "when product_ids is present" do
      it 'should return the product from the ids' do
        search_hash = {product_ids: [@product1.id, @product2.id]}
        expect(Product.search search_hash).
          to contain_exactly(@product1, @product2)
      end
    end
  end
end
