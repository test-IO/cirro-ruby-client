RSpec.describe CirroIOV2::Resources::Gig do
  describe '#create' do
    let(:site) { 'http://api.cirro.io' }
    let(:client) do
      CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                            client_id: 1,
                            site: site)
    end
    let(:params) do
      {
        "title": 'Favourite programming language?',
        "description": 'Description of gig ...',
        "url": 'http://heathcote.co/zina.gibson',
        "start_at": 1652285764,
        "end_at": 1653412329,
        "total_seats": 2,
        "invitation_mode": 'auto',
        "filter_query": {
          "status": 'active',
          "segment": 'my_favorite_testers',
        },
        "tasks": [
          { "title": 'Ah, Wilderness!', "base_price": 300 },
        ],
        "notification_payload": {
          "project_title": 'Corporate Tax',
          "task_title": 'Add dataset',
          "task_type": 'Review',
        },
        "epam_options": {
          "extra_mile": true,
        },
      }
    end

    it 'creates a gig' do
      stub_api = stub_request(:post, "#{site}/v2/gigs")
                 .to_return(body: File.read('./spec/fixtures/gig/create.json'))

      gig = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(gig.class).to eq(CirroIOV2::Responses::GigResponse)
      expect(gig.object).to eq('gig')
      expect(gig.title).to eq(params[:title])
      expect(gig.tasks.class).to eq(CirroIOV2::Responses::GigTaskListResponse)
      expect(gig.tasks.object).to eq('list')
      expect(gig.tasks.data.first.class).to eq(CirroIOV2::Responses::GigTaskResponse)
      expect(gig.tasks.data.first.id).to eq('1')
      expect(gig.tasks.data.first.object).to eq('gig_task')
      expect(gig.tasks.data.first.title).to eq(params[:tasks].first[:title])
      expect(gig.tasks.data.first.base_price).to eq(params[:tasks].first[:base_price])
    end
  end
end
