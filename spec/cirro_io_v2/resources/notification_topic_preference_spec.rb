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
                 .to_return(body: File.read('./spec/fixtures/notification_topic_preference/list.json'))

      notification_topic_preferences = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(notification_topic_preferences.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceListResponse)
      expect(notification_topic_preferences.object).to eq('list')
      expect(notification_topic_preferences.url).to eq('/notification_topic_preferences')
      expect(notification_topic_preferences.data.first.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceResponse)
      expect(notification_topic_preferences.data.first.user_id).to eq('1')
      expect(notification_topic_preferences.data.first.notification_topic_id).to eq('1')
      expect(notification_topic_preferences.data.first.preferences).to eq(email: 'immediately')
    end
  end

  describe '#create' do
    let(:params) do
      {
        app_user_id: '1',
        notification_topic_id: '1',
        preferences: {
          email: 'never',
        },
      }
    end

    it 'creates a notification topic preference' do
      stub_api = stub_request(:post, "#{site}/v2/notification_topic_preferences")
                 .to_return(body: File.read('./spec/fixtures/notification_topic_preference/create.json'))

      notification_topic_preference = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(notification_topic_preference.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceResponse)
      expect(notification_topic_preference.object).to eq('notification_topic_preference')
      expect(notification_topic_preference.user_id).to eq('1')
      expect(notification_topic_preference.notification_topic_id).to eq('1')
      expect(notification_topic_preference.preferences[:email]).to eq('never')
    end
  end

  describe '#update' do
    let(:id) { '1' }
    let(:params) do
      {
        app_user_id: '1',
        notification_topic_id: '1',
        preferences: {
          email: 'never',
        },
      }
    end

    it 'updates a notification topic preference' do
      stub_api = stub_request(:post, "#{site}/v2/notification_topic_preferences/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_topic_preference/update.json'))

      notification_topic_preference = described_class.new(client).update(id, params)

      expect(stub_api).to have_been_made
      expect(notification_topic_preference.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceResponse)
      expect(notification_topic_preference.object).to eq('notification_topic_preference')
      expect(notification_topic_preference.user_id).to eq('1')
      expect(notification_topic_preference.notification_topic_id).to eq('1')
      expect(notification_topic_preference.preferences[:email]).to eq('never')
    end
  end
end
