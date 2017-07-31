require 'rails_helper'

RSpec.describe Placement, type: :model do
  it { is_expected.to respond_to :order_id }
  it { is_expected.to respond_to :product_id }
  it { is_expected.to respond_to :quantity }

  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }
end
