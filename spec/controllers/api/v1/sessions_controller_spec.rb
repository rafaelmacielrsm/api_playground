require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { FactoryGirl.create :user, password: '12345678' }
  before { include_default_accept_headers }
  describe 'POST #create' do

    before { post :create, params: { session: credentials } }

    context 'when the credentials are correct' do
      let(:credentials) { {email: user.email, password: '12345678'} }

      it { expect(response).to have_http_status(:ok) }

      it 'should return the record corresponding to the given credentials' do
        user.reload
        expect( response_attributes[:"auth-token"] ).to eql(user.auth_token)
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { {email: user.email, password: 'invalid_password'} }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_response[:errors]).to match(/Invalid.+password/) }
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }
    let(:destroy_request) { delete:destroy, params: {id: user.id} }

    it {
      destroy_request
      expect(response).to have_http_status(:no_content)
    }

    it 'should change the auth_token value' do
      expect{ destroy_request }.to change { user.reload.auth_token }
    end
  end
end
