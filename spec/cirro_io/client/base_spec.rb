RSpec.describe CirroIO::Client::Base do
  let :request_headers do
    {
      'Accept' => 'application/vnd.api+json',
      'Accept-Encoding' => 'gzip,deflate',
      'Content-Type' => 'application/vnd.api+json',
      'User-Agent' => 'Faraday v1.10.3',
      'Authorization' => 'Bearer jwt-token',
    }
  end

  let :response_headers do
    {
      'Content-Type' => 'application/json',
    }
  end

  before do
    configure_api_client
    allow(JWT).to receive(:encode).and_return('jwt-token')
  end

  describe 'jwt_authentication' do
    it 'sends correct token' do
      stub_request(:get, "#{test_site}/v1/app-workers/1")
        .with(headers: request_headers)
        .to_return(body: File.read('./spec/fixtures/app_worker.json'), headers: response_headers)

      app_worker = CirroIO::Client::AppWorker.find(1).first

      expect(app_worker.id).to eq('1')
    end

    it 'sends token correctly for custom requests as well' do
      stub_request(:post, "#{test_site}/v1/bulk/custom-endpoint")
        .with(headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'application/json',
                'User-Agent' => 'Faraday v1.10.3',
                'Authorization' => 'Bearer jwt-token',
              })
        .to_return(status: 201, body: '{}', headers: {})

      described_class.custom_post('bulk/custom-endpoint', { a: :b })
    end
  end

  describe 'configuration' do
    let(:other_site)    { 'https://api.other.cirro.io' }
    let(:other_version) { 'vXXX' }

    before do
      CirroIO::Client::AppWorker.site = "#{other_site}/#{other_version}"
    end

    it 'supports multiple backends' do
      stub_request(:get, "#{other_site}/#{other_version}/app-workers/1")
        .with(headers: request_headers)
        .to_return(body: File.read('spec/fixtures/app_worker.json'), headers: response_headers)

      expect(CirroIO::Client::AppWorker.find(1).first.id).to eq('1')

      stub_request(:get, "#{test_site}/v1/app-users/3")
        .with(headers: request_headers)
        .to_return(body: File.read('spec/fixtures/app_user.json'), headers: response_headers)

      expect(CirroIO::Client::AppUser.find(3).first.id).to eq('3')
    end
  end
end
