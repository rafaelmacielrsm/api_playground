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
end
