RSpec.describe CirroIOV2::Resources::NotificationLayout do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:id) { '1' }

  describe '#create' do
    let(:params) do
      {
        "name": 'tester_layout',
        "templates": [
          {
            "notification_configuration_id": '1',
            "body": '<p>Hello {{recipient_first_name}},</p>{{yield content}}<footer></footer>',
          },
        ],
      }
    end

    it 'creates a notification_layout' do
      stub_api = stub_request(:post, "#{site}/v2/notification_layouts")
                 .to_return(body: File.read('./spec/fixtures/notification_layout/create.json'))

      notification_layout = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(notification_layout.class).to eq(CirroIOV2::Responses::NotificationLayoutResponse)
      expect(notification_layout.object).to eq('notification_layout')
      expect(notification_layout.name).to eq(params[:name])
      expect(notification_layout.templates.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateListResponse)
      expect(notification_layout.templates.object).to eq('list')
      expect(notification_layout.templates.data.first.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateResponse)
      expect(notification_layout.templates.data.first.notification_configuration_id).to eq(params[:templates].first[:notification_configuration_id])
      expect(notification_layout.templates.data.first.body).to eq(params[:templates].first[:body])
    end
  end

  describe '#update' do
    let(:update_params) do
      {
        "name": 'new_tester_layout',
      }
    end

    it 'updates a notification_layout' do
      stub_api = stub_request(:post, "#{site}/v2/notification_layouts/#{id}")
                 .to_return(body: File.read('./spec/fixtures/notification_layout/update.json'))

      updated_notification_layout = described_class.new(client).update(id, update_params)

      expect(stub_api).to have_been_made
      expect(updated_notification_layout.class).to eq(CirroIOV2::Responses::NotificationLayoutResponse)
      expect(updated_notification_layout.object).to eq('notification_layout')
      expect(updated_notification_layout.name).to eq(update_params[:name])
      expect(updated_notification_layout.templates.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateListResponse)
      expect(updated_notification_layout.templates.object).to eq('list')
      expect(updated_notification_layout.templates.data.first.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateResponse)
    end
  end

  describe '#create_template' do
    let(:template_params) do
      {
        "notification_configuration_id": '1',
        "body": '<p>Hello {{recipient_first_name}},</p>{{yield content}}<footer></footer>',
      }
    end

    it 'creates a notification_layout_template' do
      stub_api = stub_request(:post, "#{site}/v2/notification_layouts/#{id}/notification_layout_templates")
                 .to_return(body: File.read('./spec/fixtures/notification_layout/create_template.json'))

      notification_layout_template = described_class.new(client).create_template(id, template_params)

      expect(stub_api).to have_been_made
      expect(notification_layout_template.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateResponse)
      expect(notification_layout_template.id).to eq('1')
      expect(notification_layout_template.notification_configuration_id).to eq(template_params[:notification_configuration_id])
      expect(notification_layout_template.notification_layout_id).to eq('1')
      expect(notification_layout_template.body).to eq(template_params[:body])
    end
  end
end
