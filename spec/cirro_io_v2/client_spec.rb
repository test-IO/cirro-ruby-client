RSpec.describe CirroIOV2::Client do
  subject(:client) do
    described_class.new(
      private_key: private_key_path,
      client_id: app_id,
      site:,
    )
  end

  let(:app_id) { 'WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw' }
  let(:private_key_path) { File.read('./spec/fixtures/private_key.pem') }
  let(:site) { 'http://api.cirro.io' }

  describe 'new' do
    xit 'allows to configure client' do
    end
  end

  describe 'wrapper methods' do
    before do
      allow(CirroIOV2::Resources::User).to receive(:new)
      allow(CirroIOV2::Resources::SpaceInvitation).to receive(:new)
      allow(CirroIOV2::Resources::GigInvitation).to receive(:new)
      allow(CirroIOV2::Resources::Gig).to receive(:new)
      allow(CirroIOV2::Resources::GigResult).to receive(:new)
      allow(CirroIOV2::Resources::GigTimeActivity).to receive(:new)
      allow(CirroIOV2::Resources::Payout).to receive(:new)
      allow(CirroIOV2::Resources::NotificationBroadcast).to receive(:new)
      allow(CirroIOV2::Resources::NotificationTopicPreference).to receive(:new)
      allow(CirroIOV2::Resources::NotificationTopic).to receive(:new)
      allow(CirroIOV2::Resources::NotificationConfiguration).to receive(:new)
      allow(CirroIOV2::Resources::NotificationLayoutTemplate).to receive(:new)
      allow(CirroIOV2::Resources::NotificationLayout).to receive(:new)
      allow(CirroIOV2::Resources::NotificationLocale).to receive(:new)
      allow(CirroIOV2::Resources::NotificationTemplate).to receive(:new)
    end

    it 'initializes User when #User is called' do
      client.User

      expect(CirroIOV2::Resources::User).to have_received(:new)
    end

    it 'initializes SpaceInvitation when #SpaceInvitation is called' do
      client.SpaceInvitation

      expect(CirroIOV2::Resources::SpaceInvitation).to have_received(:new)
    end

    it 'initializes GigInvitation when #GigInvitation is called' do
      client.GigInvitation

      expect(CirroIOV2::Resources::GigInvitation).to have_received(:new)
    end

    it 'initializes Gig when #Gig is called' do
      client.Gig

      expect(CirroIOV2::Resources::Gig).to have_received(:new)
    end

    it 'initializes GigResult when #GigResult is called' do
      client.GigResult

      expect(CirroIOV2::Resources::GigResult).to have_received(:new)
    end

    it 'initializes GigTimeActivity when #GigTimeActivity is called' do
      client.GigTimeActivity

      expect(CirroIOV2::Resources::GigTimeActivity).to have_received(:new)
    end

    it 'initializes Payout when #Payout is called' do
      client.Payout

      expect(CirroIOV2::Resources::Payout).to have_received(:new)
    end

    it 'initializes NotificationBroadcast when #NotificationBroadcast is called' do
      client.NotificationBroadcast

      expect(CirroIOV2::Resources::NotificationBroadcast).to have_received(:new)
    end

    it 'initializes NotificationTopicPreference when #NotificationTopicPreference is called' do
      client.NotificationTopicPreference

      expect(CirroIOV2::Resources::NotificationTopicPreference).to have_received(:new)
    end

    it 'initializes NotificationTopic when #NotificationTopic is called' do
      client.NotificationTopic

      expect(CirroIOV2::Resources::NotificationTopic).to have_received(:new)
    end

    it 'initializes NotificationConfiguration when #NotificationConfiguration is called' do
      client.NotificationConfiguration

      expect(CirroIOV2::Resources::NotificationConfiguration).to have_received(:new)
    end

    it 'initializes NotificationLayoutTemplate when #NotificationLayoutTemplate is called' do
      client.NotificationLayoutTemplate

      expect(CirroIOV2::Resources::NotificationLayoutTemplate).to have_received(:new)
    end

    it 'initializes NotificationLayout when #NotificationLayout is called' do
      client.NotificationLayout

      expect(CirroIOV2::Resources::NotificationLayout).to have_received(:new)
    end

    it 'initializes NotificationLocale when #NotificationLocale is called' do
      client.NotificationLocale

      expect(CirroIOV2::Resources::NotificationLocale).to have_received(:new)
    end

    it 'initializes NotificationTemplate when #NotificationTemplate is called' do
      client.NotificationTemplate

      expect(CirroIOV2::Resources::NotificationTemplate).to have_received(:new)
    end
  end

  describe 'error handling' do
    let(:exception) { RuntimeError.new('test') }
    let(:body) { { error: 'error' } }
    let(:response) { { status: 400, body: } }

    let(:faraday_error) { Faraday::ClientError.new(exception, response) }

    before do
      allow_any_instance_of(CirroIOV2::RequestClients::Jwt).to receive(:make_request).and_raise(faraday_error) # rubocop:disable RSpec/AnyInstance
    end

    context 'when DEBUG_CIRRO_RUBY_CLIENT is not set' do
      it 'raises CirroIOV2::Errors::ClientError when request fails with 4xx' do
        expect { client.request_client.request(:foo, :bar) }.to raise_error(CirroIOV2::Errors::ClientError) do |error|
          expect(error.faraday_error.message).to eq('test')
          expect(error.message).to eq({ error: 'error' })
        end
      end
    end

    context 'when response body is empty and DEBUG_CIRRO_RUBY_CLIENT is not set' do
      let(:body) { nil }

      it 'raises CirroIOV2::Errors::ClientError when request fails with 4xx' do
        expect { client.request_client.request(:foo, :bar) }.to raise_error(CirroIOV2::Errors::ClientError) do |error|
          expect(error.faraday_error.message).to eq('test')
          expect(error.message).to eq(exception.message)
        end
      end
    end

    context 'when DEBUG_CIRRO_RUBY_CLIENT is set' do
      before do
        stub_const('ENV', { 'DEBUG_CIRRO_RUBY_CLIENT' => 'asdf' })
      end

      it 'raises the error AND logs the whole response to simplify debugging' do
        expect { client.request_client.request(:foo, :bar) }.to raise_error(CirroIOV2::Errors::ClientError) do |error|
          expect(error.message).to eq('{:status=>400, :body=>{:error=>"error"}}')
        end
      end
    end
  end
end
