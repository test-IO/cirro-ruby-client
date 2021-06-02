RSpec.describe CirroIO::Client::Reward do
  describe 'create' do
    before do
      configure_api_client
    end

    let(:app_worker) { CirroIO::Client::AppWorker.load(id: 1) }
    let(:attributes) do
      {
        title: Faker::Hipster.sentence,
        description: Faker::Hipster.paragraph,
        'billing-date': Date.today.to_s,
        amount: 100,
      }
    end

    it 'creates a reward for an app worker' do
      request_url = "#{test_site}/v1/rewards"
      stub_request(:post, request_url)
        .to_return(body: File.read('./spec/fixtures/reward.json'), headers: { 'Content-Type' => 'application/json' })

      request_body = {
        data: {
          type: 'rewards',
          relationships: {
            'app-worker': {
              data: {
                type: 'app-workers',
                id: 1,
              },
            },
          },
          attributes: attributes,
        },
      }

      reward = described_class.create(**attributes.merge(app_worker: app_worker))

      expect(a_request(:post, request_url).with(body: request_body.to_json)).to have_been_made
      expect(reward).to be_valid
      expect(reward.id).to eq('1')
    end
  end
end
