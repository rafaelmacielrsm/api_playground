require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user) }

  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:password) }
  it { expect(subject).to respond_to(:password_confirmation) }
  it { expect(subject).to respond_to(:auth_token) }

  it { expect(subject).to be_valid }

  context 'associations' do
    it { expect(subject).to have_many(:products) }

    it 'should destroy associated products on destroy' do
      3.times{FactoryGirl.create :product, user: subject}
      expect{ subject.destroy }.to change{ subject.products.length }.from(3).to(0)
    end
  end

  context 'Validations' do
    #email validations
    it { expect(subject).to validate_presence_of(:email) }

    it { expect(subject).to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    it { expect(subject).to allow_value('example@domain.com').for(:email) }

    it { expect(subject).not_to allow_value('example@').for(:email) }
    #password validation
    it { expect(subject).to validate_confirmation_of(:password) }
    #auth_token validation
    it { expect( subject ).to validate_uniqueness_of(:auth_token) }

    describe "#generate_authentication_token!" do
      let(:existing_user) {
        FactoryGirl.create(:user)
          .update_attributes(auth_token: 'AUniqueToken123')}

      let(:new_user) { FactoryGirl.build(:user, auth_token: 'AUniqueToken123') }

      it 'should generate a unique token' do
        allow(Devise).to receive(:friendly_token).and_return("AUniqueToken123")
        subject.generate_authentication_token!
        expect( subject.auth_token ).to eql("AUniqueToken123")
      end
    end

  end
end
