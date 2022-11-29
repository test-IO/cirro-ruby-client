RSpec.describe CirroIOV2::Resources::EpamHeroes do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#create' do
    let(:params) do
      {
        grantee_id: '1',
        comment: 'MyComment',
        event: 'MyEvent',
        grantor_id: '2',
        cc_emails: ['Name_Surname@example.com', 'test@test.com']
      }
    end

    let!(:stub_api) do
      stub_request(:post, "#{site}/v2/epam_heroes")
        .to_return(body: File.read('./spec/fixtures/epam_heroes/create.json'))
    end

    it 'creates a epam_heroes' do
      epam_heroes = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(epam_heroes.class).to eq(CirroIOV2::Responses::EpamHeroesResponse)
      expect(epam_heroes.content).to be_present
      expect(epam_heroes.refs).to be_present

      expect(epam_heroes.paging).to eq(nil)
      expect(epam_heroes.hasMoreResults).to eq(nil)
    end
  end
end
