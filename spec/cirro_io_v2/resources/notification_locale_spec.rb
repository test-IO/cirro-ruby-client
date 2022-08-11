RSpec.describe CirroIOV2::Resources::NotificationLocale do
  let(:site) { 'http://api.cirro.io' }
  let(:open_ssl_pub_key) { instance_double('OpenSSL::PKey::RSA') }
  let(:client) { CirroIOV2::Client.new(private_key: 'private_key',
                                       client_id: 1,
                                       site: site) }
  let(:locale) { 'de' }

  before do
    allow(OpenSSL::PKey::RSA).to receive(:new).with(any_args).and_return(open_ssl_pub_key)
    allow(JWT).to receive(:encode).with(any_args).and_return('private string')
  end

  describe '#create' do
    context 'when all params are allowed' do
      it 'creates a new locale' do
        stub_api = stub_request(:post, "#{site}/v2/notification_locales").
                     to_return(body: File.read('./spec/fixtures/notification_locale/create.json'))

        created_notification_locale = described_class.new(client).create(locale: locale)

        expect(stub_api).to have_been_made
        expect(created_notification_locale.class).to eq(CirroIOV2::Responses::NotificationLocaleResponse)
        expect(created_notification_locale.object).to eq('notification_locale')
        expect(created_notification_locale.locale).to eq(locale)
        expect(created_notification_locale.configurations.class).to eq(CirroIOV2::Responses::NotificationConfigurationListResponse)
      end
    end

    context 'when some params are not allowed' do
      it 'returns error' do
        expect { described_class.new(client).create({ locale: locale, test: 'test' }) }.to raise_error('ParamNotAllowed')
      end
    end
  end

  describe '#list' do
    it 'returns locales' do    
      stub_api = stub_request(:get, "#{site}/v2/notification_locales").
                   to_return(body: File.read('./spec/fixtures/notification_locale/list.json'))

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
