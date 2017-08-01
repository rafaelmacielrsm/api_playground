require 'rails_helper'
require 'shared_examples/an_api_show_action'
require 'shared_examples/an_api_create_action'
require 'shared_examples/an_api_update_action'
require 'shared_examples/not_findable'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:dbl_user) { double(User) }

  before { include_default_accept_headers }

  describe 'GET #show' do
    let(:send_request) { get :show, params: { id: record.id} }

    before { send_request }

    it 'should have the product ids as an embeded object' do
      expect(response_relationships).to include(:products)
    end

    it 'should return an empty array in products ids field' do
      expect(response_relationships[:products][:data]).to eq []
    end

    include_examples 'an api show action' do
      let(:record) { user }
      let(:checked_attr_symbol) { :email }
    end

    it_behaves_like 'not findable' do
      let(:send_request) { get :show, params: { id: user.id + rand(1000)} }
    end
  end

  describe 'POST #create' do
    before { post :create, params: { user: record_attr } }

    include_examples "an api create action" do
      let(:record_attr) { FactoryGirl.attributes_for :user }
      let(:record_attr_with_errs) { FactoryGirl.attributes_for :user, email: ''}
      let(:checked_attr_symbol){ :email }
      let(:expect_error_message){ /can't be blank/ }
    end
  end

  describe 'PUT/PATCH #update' do
    let(:send_request) {
      patch :update, params: { id: record.id, user: record_attr } }

    before do
      api_authorization_header(user.auth_token)
      send_request
    end

    include_examples "an api update action" do
      let(:record) { user }
      let(:record_attr) { FactoryGirl.attributes_for :user }
      let(:record_attr_with_errs) { FactoryGirl.attributes_for :user,
        email: 'example.com'}
      let(:checked_attr_symbol){ :email }
      let(:expect_error_message) { /invalid/ }
    end

    it_behaves_like 'not findable' do
      let(:send_request) {
        patch :update, params: { id: user.id + rand(1..10), user: record_attr }}
    end
  end

  describe 'DELETE #destroy' do
    let(:stub_deletion_methods) {
      allow( subject ).to receive(:current_user).and_return( dbl_user )
      allow( dbl_user ).to receive(:destroy).and_return true
    }

    before {
      api_authorization_header(user.auth_token)
      stub_deletion_methods
      delete :destroy, params: { id: user.id }
    }

    it { expect(response).to have_http_status :no_content }

    it {
      expect(subject).to have_received(:current_user)
        .with(no_args).at_least(1).times
    }

    it { expect( dbl_user ).to have_received( :destroy ).with(no_args) }
  end
end
