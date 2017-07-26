RSpec.shared_examples "an authorizable action" do
  it { expect(response).to have_http_status(:unauthorized) }
  it { expect(response.body).to eq "null" }
end
