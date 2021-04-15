RSpec.describe CirroIO::Client::GigInvitation do
  describe 'bulk_create_with' do
    before do
      configure_api_client
    end

    let(:gig) { CirroIO::Client::Gig.load(id: 1) }
    let(:gig_invitation) { described_class.new(gig: gig) }

    let(:worker_filter) { CirroIO::Client::WorkerFilter.new(filter_query: '{}') }

    it 'bulk create a gig with gig tasks and filter query' do
      request_url = "#{test_site}/v1/bulk/gigs/#{gig.id}/gig_invitations"
      stub_request(:post, request_url).to_return(body: File.read('./spec/fixtures/gig_invitations.json'),
                                                 headers: { 'Content-Type' => 'application/json' })

      created_invs = gig_invitation.bulk_create_with(worker_filter)

      expect(created_invs.count).to eq(2)

      request_body = {
        data: {
          attributes: {
            type: 'gig-invitations',
            'worker-filter': {
              type: 'worker-filters',
              'filter-query': '{}',
            },
            'auto-accept': false,
          },
        },
      }

      expect(a_request(:post, request_url).with(body: request_body.to_json)).to have_been_made
    end
  end
end
