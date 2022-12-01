RSpec.describe CirroIOV2::Resources::EpamHeroes::Badges do
  let(:site) { 'http://api.cirro.io' }
  let(:client) { CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'), client_id: 1, site: site) }

  describe '#create' do
    let(:api_badge_data) { File.read('./spec/fixtures/epam_heroes/badges/create.json') }
    let(:parsed_badge_data) { JSON.parse(api_badge_data).deep_symbolize_keys }
    let(:params) { { to: '1', comment: 'MyComment', type: 'MyEvent', from: '2', emails: ['test@example.com', 'test@test.com'] } }
    let(:request_heroes_stub) { stub_request(:post, "#{site}/v2/epam_heroes/badges").to_return(body: api_badge_data) }

    before { request_heroes_stub }

    it 'calls creation badge event for cirro client' do
      response_data = described_class.new(client).create(params)

      expect(request_heroes_stub).to have_been_made
      expect(response_data.class).to eq(CirroIOV2::Responses::EpamHeroesBadgeResponse)
      expect(response_data.content).to eq(parsed_badge_data[:content])
      expect(response_data.refs).to eq(parsed_badge_data[:refs])
      expect(response_data.paging).to eq(parsed_badge_data[:paging])
      expect(response_data.hasMoreResults).to eq(parsed_badge_data[:hasMoreResults])
    end
  end
end
