require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'GET #show' do
    let!(:user) { FactoryGirl.create :user }
    let(:user_response) { JSON.parse(response.body, symbolize_names: true) }

    context 'when a valid user id is provided' do
      before {get :show, params: { id: user.id}, format: :json }

      it {expect(response).to have_http_status(:ok) }
      it 'response should include :email' do
        expect(user_response).to include(:email)
      end
    end
    # 
    # context 'when a invalid user id is provided' do
    #   before {get :show, params: { id: user.id + 1}, format: :json }
    #   it {expect(response).to have_http_status(:not_found) }
    # end
  end
end
