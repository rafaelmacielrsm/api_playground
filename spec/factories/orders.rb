FactoryGirl.define do
  factory :order do
    user 
    total 0
    products {[FactoryGirl.create(:product)]}
  end
end
