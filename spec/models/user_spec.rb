require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user) }

  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:password) }
  it { expect(subject).to respond_to(:password_confirmation) }

  it { expect(subject).to be_valid }

  context 'Validations' do
    #email validations
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { expect(subject).to allow_value('example@domain.com').for(:email) }
    it { expect(subject).not_to allow_value('example@').for(:email) }
    #password validation
    it { expect(subject).to validate_confirmation_of(:password) }

  end
end
