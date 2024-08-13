RSpec.describe CirroIOV2::Resources::NotificationTopicPreference do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site:)
  end

  describe '#list' do
    it 'returns notification_topic_preferences' do
      stub_api = stub_request(:get, "#{site}/v2/notification_topic_preferences")
                 .to_return(body: File.read('./spec/fixtures/notification_topic_preference/list.json'), headers: { 'Content-Type' => 'application/json' })

      notification_topic_preferences = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(notification_topic_preferences.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceListResponse)
      expect(notification_topic_preferences.object).to eq('list')
      expect(notification_topic_preferences.url).to eq('/notification_topic_preferences')
      expect(notification_topic_preferences.data.first.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceResponse)
    end
  end
end
