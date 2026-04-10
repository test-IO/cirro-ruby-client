RSpec.describe CirroIOV2::Errors::ClientError do
  subject(:error) { described_class.new(faraday_error) }

  let(:exception) { RuntimeError.new('something went wrong') }
  let(:response) { { status: 422, body: } }
  let(:faraday_error) { Faraday::ClientError.new(exception, response) }

  describe '#message' do
    context 'when response body is a String' do
      let(:body) { '<html><body>Internal Server Error</body></html>' }

      it 'returns the string body as-is' do
        expect(error.message).to eq('<html><body>Internal Server Error</body></html>')
      end
    end

    context 'when response body is a Hash (parsed JSON)' do
      let(:body) { { 'error' => 'Validation failed', 'details' => ['Name is required'] } }

      it 'returns a JSON string, not a Hash' do
        expect(error.message).to be_a(String)
      end

      it 'serializes the hash to JSON' do
        expect(error.message).to eq('{"error":"Validation failed","details":["Name is required"]}')
      end
    end

    context 'when response body is nil' do
      let(:body) { nil }

      it 'falls back to the faraday_error message' do
        expect(error.message).to eq('something went wrong')
      end
    end

    context 'when response body is an empty string' do
      let(:body) { '' }

      it 'falls back to the faraday_error message' do
        expect(error.message).to eq('something went wrong')
      end
    end

    context 'when response itself is nil' do
      let(:faraday_error) { Faraday::ClientError.new(exception, nil) }

      it 'does not raise an error' do
        expect { error.message }.not_to raise_error
      end

      it 'falls back to the faraday_error message' do
        expect(error.message).to eq('something went wrong')
      end
    end

    context 'when DEBUG_CIRRO_RUBY_CLIENT env var is set' do
      before do
        stub_const('ENV', ENV.to_h.merge('DEBUG_CIRRO_RUBY_CLIENT' => 'true'))
      end

      let(:body) { { 'error' => 'Validation failed' } }

      it 'returns the full response inspect string' do
        expect(error.message).to eq(faraday_error.response.inspect)
      end

      it 'returns a String' do
        expect(error.message).to be_a(String)
      end
    end

    context 'when message is used with .encode (downstream requirement)' do
      let(:body) { { 'error' => 'Validation failed' } }

      it 'can be encoded to UTF-8 when body is a Hash' do
        expect { error.message.encode('UTF-8') }.not_to raise_error
      end
    end

    context 'when message is used with .encode for a String body' do
      let(:body) { 'Bad Request' }

      it 'can be encoded to UTF-8 when body is a String' do
        expect { error.message.encode('UTF-8') }.not_to raise_error
      end
    end

    context 'when message is used with .encode for a nil body' do
      let(:body) { nil }

      it 'can be encoded to UTF-8 when falling back to faraday message' do
        expect { error.message.encode('UTF-8') }.not_to raise_error
      end
    end
  end
end
