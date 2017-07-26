RSpec.shared_examples "an api update action" do
  context "when is successfully updated" do
    it { expect(response).to have_http_status(:ok) }

    it 'should have the new attribute in the response' do
      expect(response_attributes[checked_attr_symbol]).
        to eq record_attr[checked_attr_symbol]
    end
  end

  context 'when the updade is unsuccessful' do
    let(:record_attr) { record_attr_with_errs }

    it { expect(response).to have_http_status :unprocessable_entity }
    it { expect(json_response).to have_key(:errors) }
    it { expect(json_response[:errors]).to include(checked_attr_symbol) }
    it { expect(json_response[:errors][checked_attr_symbol]).
      to include(expect_error_message) }
  end
end
