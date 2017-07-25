require 'spec_helper'
require 'api_constraints'

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1, default: false) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true) }

  describe "#matches?" do
    let(:request) { double( host: 'api.marketplace.dev',
      headers: { "Accept" => "application/vnd.api+json; version=1" } ) }

    context "when the version matches the 'Accept' header" do
      it 'should match the request' do
        expect( api_constraints_v1.matches?( request ) ).to be(true)
      end
    end

    context "when the 'default' option is specified" do
      let(:request) { double( host: 'api.marketplace.dev' ) }

      it 'should match the request' do
        expect(api_constraints_v2.matches?( request ) ).to be(true)
      end
    end
  end
end
