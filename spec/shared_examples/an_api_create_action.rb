shared_examples_for("an api create action") do
  context 'when is successfully created' do
    it { expect(response).to have_http_status(:created) }

    it  {expect(json_response).to include(:data)}

    it 'should have the json representation of the created record' do
      expect( response_attributes[checked_attr_symbol] ).
        to eq( record_attr[checked_attr_symbol] )
    end
  end

  context 'when is not created' do
    let(:record_attr) { record_attr_with_errs }

    it { expect(response).to have_http_status(:unprocessable_entity) }
    it { expect(json_response).to include(:errors) }
    it { expect(json_response[:errors]).to include(checked_attr_symbol) }
    it { expect(json_response[:errors][checked_attr_symbol]).
      to include(expect_error_message) }
  end
end
