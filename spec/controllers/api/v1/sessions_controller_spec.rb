require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create :user, password: '12345678' }

    before { post :create, params: { session: credentials } }

    context 'when the credentials are correct' do
      let(:credentials) { {email: user.email, password: '12345678'} }

      it { expect(response).to have_http_status(:ok) }

      it 'should return the record corresponding to the given credentials' do
        user.reload
        expect( json_response[:auth_token] ).to eql(user.auth_token)
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { {email: user.email, password: 'invalid_password'} }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_response[:errors]).to match(/Invalid.+password/) }
    end
  end
end
