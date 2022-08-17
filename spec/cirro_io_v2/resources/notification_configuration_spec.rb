RSpec.describe CirroIOV2::Resources::NotificationConfiguration do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#list' do
    it 'returns a new notification configurations' do
      stub_api = stub_request(:get, "#{site}/v2/notification_configurations")
                 .to_return(body: File.read('./spec/fixtures/notification_configuration/list.json'))

      notification_configurations = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(notification_configurations.class).to eq(CirroIOV2::Responses::NotificationConfigurationListResponse)
      expect(notification_configurations.object).to eq('list')
      expect(notification_configurations.url).to eq('/notification_configurations')
      expect(notification_configurations.data.first.class).to eq(CirroIOV2::Responses::NotificationConfigurationResponse)
      expect(notification_configurations.data.first.object).to eq('notification_configuration')
      expect(notification_configurations.data.first.locale).to eq('de')
    end
  end
end
