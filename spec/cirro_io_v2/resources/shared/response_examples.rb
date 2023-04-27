RSpec.shared_examples_for 'responses' do
  context 'when API endpoint changes attribute order or name' do
    it 'does not mess with the response attributes' do
      fixture_body.transform_keys! { |key| replace_keys[key] ? replace_keys[key] : key }
      stub_request(request_action, request_url).to_return(body: fixture_body.to_json)

      expect(subject.class).to eq(expected_response_class)
      replace_keys.each do |key, _|
        expect(subject.send(key)).to be_nil
      end

      expected_response.each do |key, value|
        if value.is_a?(Hash)
          expect(subject.send(key)).to eq(value.deep_symbolize_keys)
        else
          expect(subject.send(key)).to eq(value)
        end
      end
    end
  end
end
