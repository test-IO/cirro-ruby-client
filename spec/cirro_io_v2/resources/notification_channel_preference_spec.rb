RSpec.describe CirroIOV2::Resources::NotificationChannelPreference do
    let(:site) { 'http://api.cirro.io' }
    let(:client) { CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                                         client_id: 1,
                                         site: site) }
  
    describe '#create' do
      it 'creates a new locale' do
        stub_api = stub_request(:get, "#{site}/v2/notification_channel_preferences").
                      to_return(body: File.read('./spec/fixtures/notification_channel_preference/list.json'))

        notification_channel_preferences = described_class.new(client).list

        expect(stub_api).to have_been_made
        expect(notification_channel_preferences.class).to eq(CirroIOV2::Responses::NotificationChannelPreferenceListResponse)
        expect(notification_channel_preferences.object).to eq('list')
        expect(notification_channel_preferences.url).to eq('/notification_channel_preferences')
        expect(notification_channel_preferences.data.first.class).to eq(CirroIOV2::Responses::NotificationChannelPreferenceResponse)
      end
    end
  end
  