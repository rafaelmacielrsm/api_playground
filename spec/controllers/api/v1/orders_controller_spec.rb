require 'rails_helper'
require 'shared_examples/authorizable_action'
require 'shared_examples/an_api_show_action'


RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:current_user) { FactoryGirl.create :user }
  let(:order_response) { json_response }
  let(:set_auth_token_header) {
    api_authorization_header( current_user.auth_token) }

  before do
    include_default_accept_headers
    set_auth_token_header
  end

  describe 'GET #index' do
    before do
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, params: {user_id: current_user.id }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_data).to have(4).items }

    it_behaves_like 'an authorizable action' do
      let(:set_auth_token_header) { api_authorization_header("invalid token") }
    end
  end

  describe 'GET #show' do
    let(:order) { FactoryGirl.create :order, user: current_user }

    before { get :show, params: {user_id: current_user.id, id: order.id} }

    include_examples 'an api show action' do
      let(:record) { order }
    end

    it_behaves_like 'an authorizable action' do
      let(:set_auth_token_header) { api_authorization_header("invalid token") }
    end
  end
end
