RSpec.describe CirroIOV2::Resources::EPAMHeroes do
  let(:site) { 'http://api.cirro.io' }
  let(:employee_id) { '1' }
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

    it 'creates a epam_heroes' do
      stub_api = stub_request(:post, "#{site}/v2/epam_heroes")
                   .to_return(body: File.read('./spec/fixtures/epam_heroes/create.json'))

      epam_heroes = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(epam_heroes.class).to eq(CirroIOV2::Responses::EPAMHeroesResponse)
      expect(epam_heroes.object).to eq('epam_heroes')
      expect(epam_heroes.token).to be_present
      expect(epam_heroes.comment).to eq(params[:comment])
      expect(epam_heroes.comment).to be_present
      expect(epam_heroes.event).to eq(params[:event])
      expect(epam_heroes.event).to be_present
      expect(epam_heroes.assigner_type).to eq(params[:assigner_type])
      expect(epam_heroes.cc_emails).to eq(params[:cc_emails])
    end
  end
end
