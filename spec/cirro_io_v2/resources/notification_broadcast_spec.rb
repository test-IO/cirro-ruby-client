RSpec.describe CirroIOV2::Resources::NotificationBroadcast do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:locale) { 'de' }

  let(:params) do
    {
      "payload": {
        "key": 'value',
      },
      "recipients": {
        "user_ids": ['1', '2'],
      },
      "notification_channel_id": '1',
    }
  end

  describe '#create' do
    context 'when all params are allowed' do
      it 'creates a new NotificationBroadcast' do
        stub_api = stub_request(:post, "#{site}/v2/notification_broadcasts")
                   .to_return(body: File.read('./spec/fixtures/notification_broadcast/create.json'))

        created_notification_broadcast = described_class.new(client).create(params)

        expect(stub_api).to have_been_made
        expect(created_notification_broadcast.class).to eq(CirroIOV2::Responses::NotificationBroadcastResponse)
        expect(created_notification_broadcast.object).to eq('notification_broadcast')
        expect(created_notification_broadcast.notification_channel_id).to eq('1')
      end
    end

    context 'when some params are not allowed' do
      it 'returns error' do
        expect { described_class.new(client).create({ locale: locale, test: 'test' }) }.to raise_error('ParamNotAllowed')
      end
    end
  end
end
