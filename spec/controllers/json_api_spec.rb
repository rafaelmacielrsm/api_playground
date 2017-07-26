require 'rails_helper'

class JsonApiSpecification < ApplicationController

end

RSpec.describe JsonApiSpecification, type: :controller do
  controller do
    def index
      render json: {}, status: :ok
    end
  end

  context "when the 'Accept' and 'Content-Type' header are empty" do
    before do
      request.headers['Accept'] = ""
      request.headers['Content-Type'] = ""
      get :index
    end

    it{ expect(response).to have_http_status(:unsupported_media_type) }
  end

  context "when the 'Accept' and 'Content-Type' header are wrong" do
    before do
      request.headers['Accept'] = "application/vndjson"
      request.headers['Content-Type'] = "application/vndjson"
      get :index
    end

    it{ expect(response).to have_http_status(:unsupported_media_type) }
  end

  context "when only the 'Accept' header is wrong" do
    before do
      request.headers['Accept'] = "application/vndjson"
      request.headers['Content-Type'] = "application/vnd.api+json"
      get :index
    end

    it{ expect(response).to have_http_status(:not_acceptable) }
  end

  context "when only the 'Content-Type' header is wrong" do
    before do
      request.headers['Accept'] = "application/vnd.api+json"
      request.headers['Content-Type'] = "application/vnd.aon"
      get :index
    end

    it{ expect(response).to have_http_status(:unsupported_media_type) }
  end

  context "when both the 'Content-Type' and 'Accept' header are correct" do
    before do
      request.headers['Accept'] = "application/vnd.api+json"
      request.headers['Content-Type'] = "application/vnd.api+json"
      get :index
    end

    it{ expect(response).to have_http_status(:ok) }
  end
end
