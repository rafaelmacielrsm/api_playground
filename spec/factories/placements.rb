FactoryGirl.define do
  factory :placement do
    order nil
    product nil
    quantity { Random.new.rand(1..3) }
  end
end
