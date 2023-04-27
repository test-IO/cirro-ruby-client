RSpec.describe CirroIOV2::Resources::NotificationTopic do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:id) { '1' }
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

  describe '#find' do
    it 'returns a notification topic' do
      stub_api = stub_request(:get, "#{site}/v2/notification_topics/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_topic/find.json'))

      notification_topic = described_class.new(client).find(id)

      expect(stub_api).to have_been_made
      expect(notification_topic.class).to eq(CirroIOV2::Responses::NotificationTopicResponse)
      expect(notification_topic.object).to eq('notification_topic')
      expect(notification_topic.name).to eq('new_gig_invitation')
      expect(notification_topic.templates.class).to eq(CirroIOV2::Responses::NotificationTemplateListResponse)
      expect(notification_topic.templates.data.first.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
    end

    context 'when testing response' do
      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/notification_topic/find.json')) }
      let(:request_url) { "#{site}/v2/notification_topics/#{id}" }
      let(:request_action) { :get }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'name' => 'title',
          'templates' => 'something'
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::NotificationTopicResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      subject { described_class.new(client).find(id) }

      include_examples 'responses'
    end
  end

  describe '#update' do
    it 'returns an updated notification topic' do
      stub_api = stub_request(:post, "#{site}/v2/notification_topics/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_topic/update.json'))

      notification_topic = described_class.new(client).update(id, params)

      expect(stub_api).to have_been_made
      expect(notification_topic.class).to eq(CirroIOV2::Responses::NotificationTopicResponse)
      expect(notification_topic.object).to eq('notification_topic')
      expect(notification_topic.name).to eq('new_gig_invitation')
      expect(notification_topic.preferences[:email]).to eq('never')
      expect(notification_topic.templates.class).to eq(CirroIOV2::Responses::NotificationTemplateListResponse)
      expect(notification_topic.templates.data.first.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
    end
  end

  describe '#list' do
    it 'returns notification_topics' do
      stub_api = stub_request(:get, "#{site}/v2/notification_topics")
                 .to_return(body: File.read('./spec/fixtures/notification_topic/list.json'))

      notification_topic = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(notification_topic.class).to eq(CirroIOV2::Responses::NotificationTopicListResponse)
      expect(notification_topic.object).to eq('list')
      expect(notification_topic.data.first.class).to eq(CirroIOV2::Responses::NotificationTopicResponse)
      expect(notification_topic.url).to eq('/notification_topics')
      expect(notification_topic.has_more).to be_falsey
    end
  end

  describe '#create' do
    it 'creates a new notification topic' do
      stub_api = stub_request(:post, "#{site}/v2/notification_topics")
                 .to_return(body: File.read('./spec/fixtures/notification_topic/create.json'))

      notification_topic = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(notification_topic.class).to eq(CirroIOV2::Responses::NotificationTopicResponse)
      expect(notification_topic.object).to eq('notification_topic')
      expect(notification_topic.name).to eq('new_gig_invitation')
      expect(notification_topic.templates.class).to eq(CirroIOV2::Responses::NotificationTemplateListResponse)
      expect(notification_topic.templates.data.first.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
    end
  end

  describe '#delete' do
    it 'deletes a notification topic' do
      stub_api = stub_request(:delete, "#{site}/v2/notification_topics/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_topic/delete.json'))

      deleted_notification_topic = described_class.new(client).delete(id)

      expect(stub_api).to have_been_made
      expect(deleted_notification_topic.class).to eq(CirroIOV2::Responses::NotificationTopicDeleteResponse)
      expect(deleted_notification_topic.id).to eq(id)
      expect(deleted_notification_topic.object).to eq('notification_topic')
      expect(deleted_notification_topic.deleted).to eq(true)
    end
  end
end
