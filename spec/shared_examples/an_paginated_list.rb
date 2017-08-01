RSpec.shared_examples "an paginated list" do
  it { expect(json_response).to have_key(:meta) }
  it { expect(response_meta).to have_key(:pagination) }
  it { expect(response_meta[:pagination]).to have_key(:"per-page") }
  it { expect(response_meta[:pagination]).to have_key(:"total-page") }
  it { expect(response_meta[:pagination]).to have_key(:"total-objects") }
end
