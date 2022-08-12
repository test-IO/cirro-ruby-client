RSpec.describe CirroIO::Client::AppUser do
  describe 'create' do
    before do
      configure_api_client
    end

    let(:email) { Faker::Internet.email }
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:password) { 'abcd12345' }
    let(:time_zone) { 'Berlin' }

    it 'creates a app user' do
      stub_request(:post, "#{test_site}/v1/app-users")
        .to_return(body: File.read('./spec/fixtures/app_user.json'), headers: { 'Content-Type' => 'application/json' })

      app_user = described_class.new(email: email,
                                     first_name: first_name,
                                     last_name: last_name,
                                     password: password,
                                     time_zone: time_zone)

      app_user.save

      expect(app_user).to be_valid
      expect(app_user.id).to eq('3')
    end
  end

  describe 'find' do
    before do
      configure_api_client
    end

    it 'finds a app user' do
      stub_request(:get, "#{test_site}/v1/app-users/3")
        .to_return(body: File.read('./spec/fixtures/app_user.json'), headers: { 'Content-Type' => 'application/json' })

      app_user = described_class.find(3).first

      expect(app_user.id).to eq('3')
    end

    it 'returns app user with app-worker and gig invitations' do
      stub_request(:get, "#{test_site}/v1/app-users/30?include=app-worker.gig-invitations")
        .to_return(body: File.read('./spec/fixtures/app_user_with_app_worker_and_gig_invitations.json'), headers: { 'Content-Type' => 'application/json' })

      app_user = described_class.includes('app_worker.gig_invitations').find(30).first

      expect(app_user.id).to eq('30')
      expect(app_user.app_worker).to be_present
      expect(app_user.app_worker.class.to_s).to eq('CirroIO::Client::AppWorker')

      expect(app_user.app_worker.gig_invitations.count).to eq(1)
      expect(app_user.app_worker.gig_invitations[0].class.to_s).to eq('CirroIO::Client::GigInvitation')
    end
  end
end
