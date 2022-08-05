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

    let(:worker_filter) { CirroIO::Client::WorkerFilter.new(filter_query: '{}') }
    let(:gig_task1) { CirroIO::Client::GigTask.new(title: Faker::Hipster.sentence, base_price: 5) }
    let(:gig_task2) { CirroIO::Client::GigTask.new(title: Faker::Hipster.sentence, base_price: 10) }

    it 'bulk create a gig with gig tasks and filter query' do
      stub_request(:post, "#{test_site}/v1/bulk/gigs")
        .to_return(body: File.read('./spec/fixtures/gig_with_filter_and_gig_tasks.json'), headers: { 'Content-Type' => 'application/json' })

      created_gig = gig.bulk_create_with(worker_filter, [gig_task1, gig_task2])

      expect(created_gig).to be_valid
      expect(created_gig.id).to eq('15')
      expect(created_gig.worker_filter.id).to eq('20')
      expect(created_gig.gig_tasks.map(&:id)).to eq(['24', '25'])
    end
  end

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe 'bulk_archive_with' do
    before do
      configure_api_client
    end

    let(:gig_task) { CirroIO::Client::GigTask.new(id: 14) }

    let(:gig) do
      described_class.new(id: 10, gig_tasks: [gig_task])
    end

    let(:app_worker1) { CirroIO::Client::AppWorker.new(id: 8) }
    let(:app_worker2) { CirroIO::Client::AppWorker.new(id: 9) }

    let(:gig_results) do
      [CirroIO::Client::GigResult.new(app_worker: app_worker1,
                                      gig_task: gig_task,
                                      title: Faker::Hipster.sentence,
                                      description: Faker::Hipster.paragraph,
                                      quantity: 2),
       CirroIO::Client::GigResult.new(app_worker: app_worker2,
                                      gig_task: gig_task,
                                      title: Faker::Hipster.sentence,
                                      description: Faker::Hipster.paragraph,
                                      quantity: 4)]
    end

    let(:gig_time_activities) do
      [CirroIO::Client::GigTimeActivity.new(app_worker: app_worker1,
                                            description: Faker::Hipster.paragraph,
                                            date: Time.current,
                                            duration_in_ms: 66000),
       CirroIO::Client::GigTimeActivity.new(app_worker: app_worker2,
                                            description: Faker::Hipster.paragraph,
                                            date: Time.current,
                                            duration_in_ms: 56000)]
    end

    it 'archives a gig with gig results and gig time activites' do
      stub_request(:post, "#{test_site}/v1/bulk/gigs/10/archive")
        .to_return(body: File.read('./spec/fixtures/archived_gig_with_gig_results_and_gig_time_activities.json'),
                   headers: { 'Content-Type' => 'application/json' })

      archived_gig = gig.bulk_archive_with(gig_results, gig_time_activities)

      expect(archived_gig).to be_valid
      expect(archived_gig.id).to eq('10')
      expect(archived_gig.archive_at).to eq('2020-11-30T10:30:56.000Z')
      expect(archived_gig.gig_results.map(&:id)).to eq(['1', '2'])
      expect(archived_gig.gig_time_activities.map(&:id)).to eq(['1', '2'])
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
