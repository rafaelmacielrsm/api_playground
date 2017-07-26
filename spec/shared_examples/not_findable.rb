RSpec.shared_examples "not findable" do
  it { expect(response).to have_http_status(:not_found) }
  it { expect(response.body).to eq "null" }
end
