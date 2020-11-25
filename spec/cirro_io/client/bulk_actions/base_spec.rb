RSpec.describe CirroIO::Client::BulkActions::Base do
  describe 'jwt_authentication' do
    before do
      configure_api_client
    end

    it 'sends correct token' do
      allow(JWT).to receive(:encode).and_return('jwt-token')

      stub_request(:post, "#{test_site}/v1/bulk/gigs")
        .with(headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'application/json',
                'User-Agent' => 'Faraday v1.0.1',
                'Authorization' => 'Bearer jwt-token',
              })
        .to_return(status: 201, body: '{}', headers: {})

      CirroIO::Client::BulkActions::Gig.bulk_create({})
    end
  end
end
