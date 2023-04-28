RSpec.describe CirroIOV2::Resources::NotificationLocale do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:locale) { 'de' }

  describe '#create' do
    context 'when all params are allowed' do
      it 'creates a new locale' do
        stub_api = stub_request(:post, "#{site}/v2/notification_locales")
                   .to_return(body: File.read('./spec/fixtures/notification_locale/create.json'))

        created_notification_locale = described_class.new(client).create(locale: locale)

        expect(stub_api).to have_been_made
        expect(created_notification_locale.class).to eq(CirroIOV2::Responses::NotificationLocaleResponse)
        expect(created_notification_locale.object).to eq('notification_locale')
        expect(created_notification_locale.locale).to eq(locale)
        expect(created_notification_locale.configurations.class).to eq(CirroIOV2::Responses::NotificationConfigurationListResponse)
      end
    end

    context 'when testing response' do
      subject { described_class.new(client).create(locale: locale) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/notification_locale/create.json')) }
      let(:request_url) { "#{site}/v2/notification_locales" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'configurations' => 'notification_configs',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::NotificationLocaleResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      include_examples 'responses'
    end
  end

  describe '#list' do
    it 'returns locales' do
      stub_api = stub_request(:get, "#{site}/v2/notification_locales")
                 .to_return(body: File.read('./spec/fixtures/notification_locale/list.json'))

      list_notification_locale = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(list_notification_locale.class).to eq(CirroIOV2::Responses::NotificationLocaleListResponse)
      expect(list_notification_locale.object).to eq('list')
      expect(list_notification_locale.data.size).to eq 1
      expect(list_notification_locale.data.first.class).to eq(CirroIOV2::Responses::NotificationLocaleResponse)
      expect(list_notification_locale.data.first.locale).to eq(locale)
    end
  end
end
