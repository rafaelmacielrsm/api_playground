require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:dbl_user) { double(User) }

  before { include_default_accept_headers }

  describe 'GET #show' do
    context 'when a valid user id is provided' do
      before {get :show, params: { id: user.id} }

      it {expect(response).to have_http_status(:ok) }
      it 'response should include :email' do
        expect(json_response).to include(:email)
      end
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      let!(:user_attributes) { FactoryGirl.attributes_for :user }

      before{ post :create, params: { user: user_attributes }}

      it { expect(response).to have_http_status(:created) }

      it 'response should include :email' do
        expect(json_response).to include(:email)
      end

      it 'response should have the json representation of the created record' do
        expect( json_response[:email] ).to eq( user_attributes[:email] )
      end
    end

    context 'when is not created' do
      let!(:user_attributes) { FactoryGirl.attributes_for :user, email: ''}

      before{ post :create, params: { user: user_attributes } }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_response).to include(:errors) }

      it 'should include :email in the errors hash' do
        expect(json_response[:errors]).to include(:email)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    before do
      api_authorization_header(user.auth_token)
      patch :update,  params: { id: user.id, user: { email: new_user_email } }
    end

    context "when is successfully updated" do
      let(:new_user_email) { FFaker::Internet.email }

      it { expect(response).to have_http_status(:ok) }

      it 'should have the recently changed email in the response' do
        expect(json_response[:email]).to eql new_user_email
      end
    end

    context 'when the updade is unsuccessful' do
      let(:new_user_email) { 'example.com' }

      it { expect(response).to have_http_status :unprocessable_entity }

      it { expect(json_response).to have_key(:errors) }

      it 'should have :email in the errors hash' do
        expect(json_response[:errors]).to include(:email)
      end

      it { expect(json_response[:errors][:email].to_s).to match(/invalid/) }
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
