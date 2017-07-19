FactoryGirl.define do
  factory :product do
    title FFaker::Product.product_name
    price Random.new.rand(999.99)
    published false
    user
  end
end
