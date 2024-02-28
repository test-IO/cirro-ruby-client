RSpec.describe CirroIOV2::Resources::NotificationLayout do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site:)
  end
  let(:id) { '1' }

  describe '#list' do
    it 'returns list of a notifications layouts' do
      stub_api = stub_request(:get, "#{site}/v2/notification_layouts")
                 .to_return(body: File.read('./spec/fixtures/notification_layout/list.json'))

      layouts = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(layouts.class).to eq(CirroIOV2::Responses::NotificationLayoutListResponse)
      expect(layouts.object).to eq('list')
      expect(layouts.data.first.class).to eq(CirroIOV2::Responses::NotificationLayoutResponse)
      expect(layouts.data.first.id).to eq('1')
      expect(layouts.data.first.object).to eq('notification_layout')
      expect(layouts.data.first.name).to eq('tester_layout')
      expect(layouts.data.first.templates.class).to eq(CirroIOV2::Responses::NotificationLayoutTemplateListResponse)
      expect(layouts.data.first.templates.data.first.id).to eq('1')
      expect(layouts.data.first.templates.data.first.notification_configuration_id).to eq('1')
      expect(layouts.data.first.templates.data.first.notification_layout_id).to eq('1')
      expect(layouts.data.first.templates.data.first.body).not_to be_nil
    end
  end

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

    context 'when testing response' do
      subject { described_class.new(client).create(params) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/notification_layout/create.json')) }
      let(:request_url) { "#{site}/v2/notification_layouts" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'templates' => 'content',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::NotificationLayoutResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      include_examples 'responses'
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
