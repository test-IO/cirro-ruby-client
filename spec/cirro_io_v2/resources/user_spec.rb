RSpec.describe CirroIOV2::Resources::User do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:user_id) { '1' }
  let(:params) do
    {
      "locale": 'de',
      "channels": [
        {
          "id": '1',
          "preferences": {
            "email": 'immediately',
          },
        },
      ],
    }
  end

  describe '#find' do
    it 'finds user' do
      stub_api = stub_request(:get, "#{site}/v2/users/#{user_id}")
                 .to_return(body: File.read('./spec/fixtures/user/find.json'))

      user = described_class.new(client).find(user_id)

      expect(stub_api).to have_been_made
      expect(user.class).to eq(CirroIOV2::Responses::UserResponse)
      expect(user.object).to eq('user')
      expect(user.first_name).to eq('Grazyna')
      expect(user.epam[:id]).to eq('12345')
    end
  end

  describe '#notification_preferences' do
    it 'creates notification_preferences' do
      stub_api = stub_request(:post, "#{site}/v2/users/#{user_id}/notification_preferences")
                 .to_return(body: File.read('./spec/fixtures/user/notification_preferences.json'))

      notification_preferences = described_class.new(client).notification_preferences(user_id, params)

      expect(stub_api).to have_been_made
      expect(notification_preferences.class).to eq(CirroIOV2::Responses::UserNotificationPreferenceResponse)
      expect(notification_preferences.object).to eq('notification_preference')
      expect(notification_preferences.locale).to eq('de')
      expect(notification_preferences.channels.class).to eq(CirroIOV2::Responses::NotificationChannelListResponse)
      expect(notification_preferences.channels.data.first.class).to eq(CirroIOV2::Responses::NotificationChannelResponse)
    end
  end
end
