FactoryGirl.define do
  factory :order do
    user nil
    total 0
    products {[FactoryGirl.create(:product)]}
  end
end
