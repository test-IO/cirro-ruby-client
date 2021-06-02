RSpec.describe CirroIO::Client::Reward do
  describe 'create' do
    before do
      configure_api_client
    end

    let(:app_worker) { CirroIO::Client::AppWorker.load(id: 1) }

    it 'creates a reward for an app worker' do
      request_url = "#{test_site}/v1/rewards"
      stub_request(:post, request_url)
        # .to_return(body: File.read('./spec/fixtures/app_worker.json'), headers: { 'Content-Type' => 'application/json' })

      request_body = {
        data: {
          type: 'rewards',
          relationships: {
            'app-worker': {
              data: {
                type: 'app-workers',
                id: 1
              }
            }
          },
          attributes: {
            title: 'Title',
            description: 'Description',
            'billing-date': Date.today.to_s,
            amount: 100
          }
        }
      }

      described_class.create(title: 'Title', description: 'Description', billing_date: Date.today.to_s, amount: 100, app_worker: app_worker)

      expect(a_request(:post, request_url).with(body: request_body.to_json)).to have_been_made
      # stub_request(:get, "#{test_site}/v1/app-users/4")
      #   .to_return(body: File.read('./spec/fixtures/app_user.json'), headers: { 'Content-Type' => 'application/json' })
      #
      # app_worker = described_class.new
      # app_worker.app_user = CirroIO::Client::AppUser.find(4).first
      # app_worker.worker_document = {}
      #
      # app_worker.save
      #
      # expect(app_worker).to be_valid
      # expect(app_worker.id).to eq('1')
    end
  end
end
