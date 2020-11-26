RSpec.describe CirroIO::Client::Gig do
  describe 'bulk_create_with' do
    before do
      configure_api_client
    end

    let(:gig) do
      described_class.new(title: Faker::Hipster.sentence,
                          description: Faker::Hipster.paragraph,
                          url: Faker::Internet.url,
                          total_seats: 10,
                          automatic_invites: true,
                          archive_at: 1.month.from_now)
    end

    let(:worker_invitation_filter) { CirroIO::Client::WorkerInvitationFilter.new(filter_query: '{}') }
    let(:gig_task1) { CirroIO::Client::GigTask.new(title: Faker::Hipster.sentence, base_price: 5) }
    let(:gig_task2) { CirroIO::Client::GigTask.new(title: Faker::Hipster.sentence, base_price: 10) }

    it 'bulk create a gig with gig tasks and filter query' do
      stub_request(:post, "#{test_site}/v1/bulk/gigs")
        .to_return(body: File.read('./spec/fixtures/gig_with_filter_and_gig_tasks.json'), headers: { 'Content-Type' => 'application/json' })

      created_gig = gig.bulk_create_with(gig_tasks: [gig_task1, gig_task2], worker_invitation_filter: worker_invitation_filter)

      expect(created_gig).to be_valid
      expect(created_gig.id).to eq('12')
      expect(created_gig.worker_invitation_filter.id).to eq('13')
      expect(created_gig.gig_tasks.map(&:id)).to eq(%w[18 19])
    end
  end
end
