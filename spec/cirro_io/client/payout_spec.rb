RSpec.describe CirroIO::Client::Payout do
  let(:app_worker) { CirroIO::Client::AppWorker.load id: 1 }

  let :request_headers do
    {
      'Accept' => 'application/vnd.api+json',
      'Accept-Encoding' => 'gzip,deflate',
      'Content-Type' => 'application/vnd.api+json',
      'User-Agent' => 'Faraday v1.1.0',
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

  describe '.create' do
    let(:request_url) { "#{test_site}/v1/payouts" }
    let(:payout) { described_class.create app_worker: app_worker, **attributes }
    let(:attributes) do
      {
        title: Faker::Hipster.sentence,
        description: Faker::Hipster.paragraph,
        'billing-date': Date.today.to_s,
        amount: 100,
      }
    end

    before do
      stub_request(:post, request_url)
        .with(headers: request_headers)
        .to_return(body: File.read('./spec/fixtures/payout.json'), headers: response_headers)
    end

    it 'creates a payout for the app worker' do
      request_body = {
        data: {
          type: 'payouts',
          relationships: {
            'app-worker': {
              data: {
                type: 'app-workers',
                id: 1,
              },
            },
          },
          attributes: attributes
        }
      }

      expect(payout).to be_persisted
      expect(a_request(:post, request_url).with(body: request_body.to_json)).to have_been_made
    end
  end
end
