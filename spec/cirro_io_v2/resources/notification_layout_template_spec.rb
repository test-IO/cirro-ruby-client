RSpec.describe CirroIOV2::Resources::NotificationLayoutTemplate do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:id) { '1' }
  let(:params) do
    {
      "notification_configuration_id": '1',
      "body": '<p>Hello {{recipient_first_name}},</p>{{yield content}}<footer></footer>',
    }
  end

  describe '#update' do
    it 'updates a notification_layout_template' do
      stub_api = stub_request(:post, "#{site}/v2/notification_layout_templates/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_layout_template/update.json'))

      notification_layout_template = described_class.new(client).update(id, params)

      expect(stub_api).to have_been_made
      expect(notification_layout_template.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateResponse)
      expect(notification_layout_template.id).to eq(id)
      expect(notification_layout_template.notification_configuration_id).to eq(params[:notification_configuration_id])
      expect(notification_layout_template.notification_layout_id).to eq('1')
      expect(notification_layout_template.body).to eq(params[:body])
    end

    context 'when testing response' do
      subject { described_class.new(client).update(id, params) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/notification_layout_template/update.json')) }
      let(:request_url) { "#{site}/v2/notification_layout_templates/#{id}" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'body' => 'content',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::NotificationLayoutTemplateResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      include_examples 'responses'
    end
  end

  describe '#delete' do
    it 'deletes a notification_layout_template' do
      stub_api = stub_request(:delete, "#{site}/v2/notification_layout_templates/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_layout_template/delete.json'))

      deleted_notification_layout_template = described_class.new(client).delete(id)

      expect(stub_api).to have_been_made
      expect(deleted_notification_layout_template.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateDeleteResponse)
      expect(deleted_notification_layout_template.id).to eq(id)
      expect(deleted_notification_layout_template.object).to eq('notification_layout_template')
      expect(deleted_notification_layout_template.deleted).to eq(true)
    end
  end
end
