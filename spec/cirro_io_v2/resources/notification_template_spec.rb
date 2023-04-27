RSpec.describe CirroIOV2::Resources::NotificationTemplate do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:id) { '1' }

  describe '#list' do
    it 'returns notification_templates' do
      stub_api = stub_request(:get, "#{site}/v2/notification_templates")
                 .to_return(body: File.read('./spec/fixtures/notification_template/list.json'))

      notification_templates = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(notification_templates.class).to eq(CirroIOV2::Responses::NotificationTemplateListResponse)
      expect(notification_templates.object).to eq('list')
      expect(notification_templates.data.first.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
      expect(notification_templates.data.first.object).to eq('notification_template')
      expect(notification_templates.data.first.subject).to eq('New Bug Comment')
    end
  end

  describe '#create' do
    let(:params) do
      {
        'notification_topic_id': '1',
        'notification_configuration_id': '1',
        'subject': 'New Bug Comment',
        'body': "Hello {{recipient_first_name}}, you got {{#pluralize count, 'new comments'}}new comment{{/pluralize}}",
      }
    end

    it 'creates a notification_template' do
      stub_api = stub_request(:post, "#{site}/v2/notification_templates")
                 .to_return(body: File.read('./spec/fixtures/notification_template/create.json'))

      updated_notification_template = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(updated_notification_template.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
      expect(updated_notification_template.object).to eq('notification_template')
      expect(updated_notification_template.id).not_to be_nil
      expect(updated_notification_template.notification_configuration_id).to eq('1')
      expect(updated_notification_template.notification_topic_id).to eq('1')
      expect(updated_notification_template.subject).to eq(params[:subject])
      expect(updated_notification_template.body).to eq(params[:body])
    end

    context 'when testing response' do
      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/notification_template/create.json')) }
      let(:request_url) { "#{site}/v2/notification_templates" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'body' => 'content'
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::NotificationTemplateResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      subject { described_class.new(client).create(params) }

      include_examples 'responses'
    end
  end

  describe '#update' do
    let(:update_params) do
      {
        "subject": 'New Bug Comment',
        "body": "Hello {{recipient_first_name}}, you got {{#pluralize count, 'new comments'}}new comment{{/pluralize}}",
      }
    end

    it 'updates a notification_template' do
      stub_api = stub_request(:post, "#{site}/v2/notification_templates/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_template/update.json'))

      updated_notification_template = described_class.new(client).update(id, update_params)

      expect(stub_api).to have_been_made
      expect(updated_notification_template.class).to eq(CirroIOV2::Responses::NotificationTemplateResponse)
      expect(updated_notification_template.object).to eq('notification_template')
      expect(updated_notification_template.id).to eq(id)
      expect(updated_notification_template.notification_configuration_id).to eq('1')
      expect(updated_notification_template.notification_topic_id).to eq('1')
      expect(updated_notification_template.subject).to eq(update_params[:subject])
      expect(updated_notification_template.body).to eq(update_params[:body])
    end
  end

  describe '#delete' do
    it 'deletes a notification_layout_template' do
      stub_api = stub_request(:delete, "#{site}/v2/notification_templates/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_template/delete.json'))

      deleted_notification_template = described_class.new(client).delete(id)

      expect(stub_api).to have_been_made
      expect(deleted_notification_template.class).to eq(CirroIOV2::Responses::NotificationTemplateDeleteResponse)
      expect(deleted_notification_template.id).to eq(id)
      expect(deleted_notification_template.object).to eq('notification_template')
      expect(deleted_notification_template.deleted).to eq(true)
    end
  end
end
