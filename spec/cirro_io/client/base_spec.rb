RSpec.describe CirroIO::Client::Base do
  describe 'jwt_authentication' do
    before do
      configure_api_client
    end

    it 'sends correct token' do
      allow(JWT).to receive(:encode).and_return('jwt-token')

      stub_request(:get, "#{test_site}/v1/app-workers/1")
        .with(headers: {
                'Accept' => 'application/vnd.api+json',
                'Accept-Encoding' => 'gzip,deflate',
                'Content-Type' => 'application/vnd.api+json',
                'User-Agent' => 'Faraday v1.0.1',
                'Authorization' => 'Bearer jwt-token',
              })
        .to_return(body: File.read('./spec/fixtures/app_worker.json'), headers: { 'Content-Type' => 'application/json' })

      app_worker = CirroIO::Client::AppWorker.find(1).first

      expect(app_worker.id).to eq('1')
    end
  end
end
