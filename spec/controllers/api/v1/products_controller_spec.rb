require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:product_response) { json_response }
  let(:user) { FactoryGirl.create :user }
  let(:product){ FactoryGirl.create(:product, user: user) }
  let(:invalid_token) { "Invalid Token Value" }

  before{ include_default_accept_headers }

  describe 'GET #show' do
    let(:product) { FactoryGirl.create(:product) }

    before{ get :show, params: {id: product.id} }

    it { expect(response).to have_http_status(:ok) }
    it { expect(product_response).to include(:title) }

    it "should return the json representation of the record" do
      expect(product_response[:title]).to eql(product.title)
    end
  end

  describe 'GET #index' do
    before do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(product_response).to have(4).items }
  end

  describe 'POST #create' do
    let(:product_attributes) { FactoryGirl.attributes_for(:product) }

    before { api_authorization_header(user.auth_token) }

    context 'when is successfully created' do
      before do
        post :create, params: {user_id: user.id, product: product_attributes}
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(product_response).to include(:title) }
      it 'should return the json representation of the record created' do
        expect(product_response[:title]).to eq(product_attributes[:title])
      end
    end

    context 'when is not successfully created' do
      before do
        product_attributes[:price] = "invalid value"
        post :create, params: {user_id: user.id, product: product_attributes}
      end

      it{ expect(response).to have_http_status(:unprocessable_entity) }

      it "should include :price in the errors hash" do
        expect(product_response[:errors]).to include(:price)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:new_name) { FFaker::Product.product_name }
    let(:update_request) do
      patch :update, params: {user_id: user.id, id: product.id,
        product: {title: new_name}}
    end
    let(:update_request_with_param_error) do
      patch :update, params: {user_id: user.id, id: product.id,
        product: {price: "new_name"}}
    end

    context 'when is successfully updated' do
      before { api_authorization_header(user.auth_token) }

      it do
        update_request
        expect(response).to have_http_status(:ok)
      end

      it "should change the product attributes" do
        expect {update_request}.to change{product.reload.title}.to(new_name)
      end
    end

    context "when isn't successfully update" do
      before do
        api_authorization_header(user.auth_token)
        update_request_with_param_error
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(product_response).to have_key(:errors) }
    end

    context "when the request doesn't have a valid token" do
      before do
        api_authorization_header(invalid_token)
        update_request
      end

      it { expect(response).to have_http_status(:unauthorized) }
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
