require 'rails_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  let(:user) { FactoryGirl.create :user }

  describe '#current_user' do
    before do
      request.headers["Authorization"] = user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it 'should return the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eql(user.auth_token)
    end
  end

  describe '#authenticate_with_token' do
    before { allow(authentication).to receive(:render) }

    context "when the current user exists" do
      before do
        allow(authentication).to receive(:current_user).and_return(user)
        authentication.authenticate_with_token!
      end

      it 'should not receive a render message' do
        expect(authentication).not_to have_received(:render)
      end
    end

    context "when the current user doesn't exist" do
      before do
        allow(authentication).to receive(:current_user).and_return(nil)
        authentication.authenticate_with_token!
      end

      it 'should receive a render message' do
        expect(authentication).to have_received(:render)
      end
    end
  end
end
