require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:user) { FactoryGirl.create :user }

  before { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'GET #show' do
    context 'when a valid user id is provided' do
      before {get :show, params: { id: user.id}, format: :json }

      it {expect(response).to have_http_status(:ok) }
      it 'response should include :email' do
        expect(parsed_response).to include(:email)
      end
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      let!(:user_attributes) { FactoryGirl.attributes_for :user }
      let(:new_user_attributes) { FactoryGirl.attributes_for :user }
      let(:new_create_request) { post :create,
        params: { user: new_user_attributes }, format: :json }
      before { post :create, params: { user: user_attributes }, format: :json }

      it { expect(response).to have_http_status(:created) }

      it 'response should include :email' do
        expect(parsed_response).to include(:email)
      end

      it 'response should have the json representation of the created record' do
        expect( parsed_response[:email] ).to eq( user_attributes[:email] )
      end

      it 'should add a record to the database' do
        expect { new_create_request }.to change{ User.count }.by(1)
      end
    end

    context 'when is not created' do
      let!(:user_attributes) { FactoryGirl.attributes_for :user, email: ''}

      before{ post :create, params: { user: user_attributes }, format: :json }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(parsed_response).to include(:errors) }

      it 'should include :email in the errors hash' do
        expect(parsed_response[:errors]).to include(:email)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    before do
      patch :update, format: :json,  params: { id: user.id, user: {
        email: new_user_email } }
    end

    context "when is successfully updated" do
      let(:new_user_email) { FFaker::Internet.email }

      it { expect(response).to have_http_status(:ok) }

      it 'should have the recently changed email in the response' do
        expect(parsed_response[:email]).to eql new_user_email
      end
    end

    context 'when the updade is unsuccessful' do
      let(:new_user_email) { 'example.com' }

      it { expect(response).to have_http_status :unprocessable_entity }

      it { expect(parsed_response).to have_key(:errors) }

      it 'should have :email in the errors hash' do
        expect(parsed_response[:errors]).to include(:email)
      end

      it { expect(parsed_response[:errors][:email].to_s).to match(/invalid/) }
    end
  end
end
