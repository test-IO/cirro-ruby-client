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
    let(:payout) { described_class.create app_worker_id: app_worker.id, **attributes }

    let(:attributes) do
      {
        title: Faker::Hipster.sentence,
        description: Faker::Hipster.paragraph,
        'billing-date': Date.today.to_s,
        amount: 100,
      }
    end

    before do
      stub_request(:post, "#{test_site}/v1/app-workers/#{app_worker.id}/payouts")
        .with(headers: request_headers)
        .to_return(body: File.read('./spec/fixtures/payout.json'), headers: response_headers)
    end

    it 'creates a payout for the app worker' do
      expect(payout).to be_persisted
      expect(payout.app_worker_id).to eq 1
    end
  end
end
