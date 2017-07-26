require 'rails_helper'
require 'shared_examples/an_api_show_action'
require 'shared_examples/an_api_create_action'
require 'shared_examples/an_api_update_action'
require 'shared_examples/not_findable'
require 'shared_examples/authorizable_action'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:product_response) { json_response }
  let(:user) { FactoryGirl.create :user }
  let(:product){ FactoryGirl.create(:product, user: user) }
  let(:invalid_token) { "Invalid Token Value" }

  before{ include_default_accept_headers }

  describe 'GET #show' do
    let(:send_request) { get :show, params: { id: record.id} }

    before { send_request }

    include_examples 'an api show action' do
      let(:record) { product }
      let(:checked_attr_symbol) { :title }
    end

    it_behaves_like 'not findable' do
      let(:send_request) { get :show, params: { id: product.id + rand(1000)} }
    end
  end

  describe 'GET #index' do
    before do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_data).to have(4).items }
  end

  describe 'POST #create' do
    let(:set_auth_token_header) { api_authorization_header(user.auth_token) }

    before do
      set_auth_token_header
      post :create, params: {user_id: user.id, product: record_attr}
    end

    include_examples 'an api create action' do
      let(:record_attr) { FactoryGirl.attributes_for(:product, user: user) }
      let(:record_attr_with_errs) {
        FactoryGirl.attributes_for(:product, title: "")}
      let(:checked_attr_symbol){ :title }
      let(:expect_error_message){ /can't be blank/ }
    end

    it_behaves_like 'an authorizable action' do
      let(:set_auth_token_header) { api_authorization_header("invalid token") }
    end
  end

  describe 'PUT/PATCH #update' do
    let(:send_request) { patch :update, params: {
      user_id: user.id, id: product.id, product: record_attr } }
    let(:set_auth_token_header) { api_authorization_header(user.auth_token) }

    before do
      set_auth_token_header
      send_request
    end

    include_examples 'an api update action' do
      let(:record) { product }
      let(:record_attr) { FactoryGirl.attributes_for :product }
      let(:record_attr_with_errs) { FactoryGirl.attributes_for :product,
        title: ""}
      let(:checked_attr_symbol){ :title }
      let(:expect_error_message) { /blank/ }
    end

    it_behaves_like 'not findable' do
      let(:send_request) { patch :update, params: {
        user_id: user.id, id: product.id + rand(1000), product: record_attr } }
    end

    it_behaves_like 'an authorizable action' do
      let(:set_auth_token_header) { api_authorization_header("invalid token") }
    end
  end

  describe 'DELETE #destroy' do
    let!(:other_product) { FactoryGirl.create(:product, user: user) }
    let(:delete_request) {
      delete :destroy, params: { user_id: user.id, id: other_product.id}
    }

    context 'when a valid token is received' do
      before {
        api_authorization_header user.auth_token
      }

      it { expect{delete_request}.to change{Product.count}.by(-1) }

      it do
        delete_request
        expect(response).to have_http_status :no_content
      end
    end

    context 'when a invalid token is received' do
      before do
        api_authorization_header invalid_token
        delete_request
      end

      it { expect(response).to have_http_status :unauthorized }
    end
  end
end
