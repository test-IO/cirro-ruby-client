RSpec.describe CirroIOV2::Resources::GigTimeActivity do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#create' do
    let(:params) do
      {
        gig_id: '1',
        user_id: '1',
        description: 'Commodi excepturi et eum.',
        duration_in_ms: 7200000,
        date: '2022-06-19',
      }
    end

    it 'creates a gig time activity' do
      stub_api = stub_request(:post, "#{site}/v2/gig_time_activities")
                 .to_return(body: File.read('./spec/fixtures/gig_time_activity/create.json'))

      gig_time_activity = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(gig_time_activity.class).to eq(CirroIOV2::Responses::GigTimeActivityResponse)
      expect(gig_time_activity.object).to eq('gig_time_activity')
      expect(gig_time_activity.gig_id).to eq(params[:gig_id])
      expect(gig_time_activity.user_id).to eq(params[:user_id])
      expect(gig_time_activity.description).to eq(params[:description])
      expect(gig_time_activity.duration_in_ms).to eq(params[:duration_in_ms])
      expect(gig_time_activity.date).to eq(params[:date])
    end

    context 'when testing response' do
      subject { described_class.new(client).create(params) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/gig_time_activity/create.json')) }
      let(:request_url) { "#{site}/v2/gig_time_activities" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'date' => 'delivery_date',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::GigTimeActivityResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      include_examples 'responses'
    end
  end

  describe '#list' do
    it 'returns gig results' do
      stub_api = stub_request(:get, "#{site}/v2/gig_time_activities")
                 .to_return(body: File.read('./spec/fixtures/gig_time_activity/list.json'))

      gig_time_activities = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(gig_time_activities.class).to eq(CirroIOV2::Responses::GigTimeActivityListResponse)
      expect(gig_time_activities.object).to eq('list')
      expect(gig_time_activities.data.first.class).to eq(CirroIOV2::Responses::GigTimeActivityResponse)
      expect(gig_time_activities.data.first.id).to eq('1')
      expect(gig_time_activities.data.first.object).to eq('gig_time_activity')
      expect(gig_time_activities.data.first.gig_id).to eq('1')
      expect(gig_time_activities.data.first.user_id).to eq('1')
    end
  end
end
