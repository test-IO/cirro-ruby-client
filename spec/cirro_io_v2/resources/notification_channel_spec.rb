RSpec.describe CirroIOV2::Resources::NotificationChannel do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:params) do
    {
      "name": 'new_gig_invitation',
      "notification_layout_id": '1',
      "preferences": {
        "email": 'immediately',
      },
      "templates": [
        {
          "notification_configuration_id": '1',
          "subject": 'New Bug Comment',
          "body": "Hello {{recipient_first_name}}, you got {{#pluralize count, 'new comments'}}new comment{{/pluralize}}",
        },
      ],
    }
  end

  describe '#create' do
    it 'creates a new notification channel' do
      stub_api = stub_request(:post, "#{site}/v2/notification_channels")
                 .to_return(body: File.read('./spec/fixtures/notification_channel/create.json'))

      notification_channel = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(notification_channel.class).to eq(CirroIOV2::Responses::NotificationChannelResponse)
      expect(notification_channel.object).to eq('notification_channel')
      expect(notification_channel.name).to eq('new_gig_invitation')
      expect(notification_channel.templates.class).to eq(CirroIOV2::Responses::NotificationTemplateListResponse)
      expect(notification_channel.templates.data.first.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
    end
  end
end
