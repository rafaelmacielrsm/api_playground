shared_examples_for('an api show action') do
  let(:data_type) { subject.controller_name }

  context "when the requested record is valid" do
    it {expect(response).to have_http_status(:ok) }

    it 'should include :data in the response' do
      expect(json_response).to include(:data)
    end

    it "should have the type field with the same value as the classname" do
      expect(json_response[:data][:type]).to eq data_type
    end
  end
end
