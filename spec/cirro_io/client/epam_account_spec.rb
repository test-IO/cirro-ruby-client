RSpec.describe CirroIO::Client::EpamAccount do
  before do
    configure_api_client
  end

  describe '.find' do
    let(:epam_idx) { "404603a5-73b7-41ff-b8a0-5954e6bcb933" }
    let(:request_url) { "#{test_site}/v1/epam-accounts/#{epam_idx}?include=skills" }

    it 'finds the epam account and include skills' do
      stub_request(:get, request_url)
        .to_return(body: File.read('./spec/fixtures/epam_account.json'), headers: { 'Content-Type' => 'application/json' })

      epam_account = described_class.includes('skills').find(epam_idx).first

      expect(epam_account.id).to eq(epam_idx)
      expect(epam_account.skills.count).to eq(3)
      expect(epam_account.skills[0].class.to_s).to eq('CirroIO::Client::Skill')

      expect(a_request(:get, request_url)).to have_been_made
    end
  end
end
