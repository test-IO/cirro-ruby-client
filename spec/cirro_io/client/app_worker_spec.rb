RSpec.describe CirroIO::Client::AppWorker do
  describe 'create' do
    before do
      configure_api_client
    end

    it 'creates a app worker' do
      stub_request(:post, "#{test_site}/v1/app-workers")
        .to_return(body: File.read('./spec/fixtures/app_worker.json'), headers: { 'Content-Type' => 'application/json' })

      stub_request(:get, "#{test_site}/v1/app-users/4")
        .to_return(body: File.read('./spec/fixtures/app_user.json'), headers: { 'Content-Type' => 'application/json' })

      app_worker = described_class.new
      app_worker.app_user = CirroIO::Client::AppUser.find(4).first
      app_worker.worker_document = {}

      app_worker.save

      expect(app_worker).to be_valid
      expect(app_worker.id).to eq('1')
    end
  end
end
