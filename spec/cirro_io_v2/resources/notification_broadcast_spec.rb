RSpec.describe CirroIOV2::Resources::NotificationBroadcast do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site:)
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
      "notification_topic_id": '1',
    }
  end

  describe '#create' do
    context 'when all params are allowed' do
      it 'creates a new NotificationBroadcast' do
        stub_api = stub_request(:post, "#{site}/v2/notification_broadcasts")
                   .to_return(body: File.read('./spec/fixtures/notification_broadcast/create.json'), headers: { 'Content-Type' => 'application/json' })

        created_notification_broadcast = described_class.new(client).create(params)

        expect(stub_api).to have_been_made
        expect(created_notification_broadcast.class).to eq(CirroIOV2::Responses::NotificationBroadcastResponse)
        expect(created_notification_broadcast.object).to eq('notification_broadcast')
        expect(created_notification_broadcast.notification_topic_id).to eq('1')
      end
    end

    context 'when testing response' do
      subject { described_class.new(client).create(params) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/notification_broadcast/create.json')) }
      let(:request_url) { "#{site}/v2/notification_broadcasts" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'payload' => 'content',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::NotificationBroadcastResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      include_examples 'responses'
    end
  end
end
