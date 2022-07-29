RSpec.describe CirroIOV2::Resources::NotificationLocale do
  let(:client) { CirroIOV2::Client.new }
  let(:locale) { 'de' }

  describe '#create' do
    let(:response) do
      { body: File.read('./spec/fixtures/notification_locale/create.json'), headers: { 'Content-Type' => 'application/json' } }
    end

    before do
      allow(client.request_client).to receive(:request).and_return(response)
    end

    context 'when all params are allowed' do
      it 'creates a new locale' do
        notification_locale = described_class.new(client)
        created_notification_locale = notification_locale.create(locale: locale)

        expect(notification_locale).to be_valid
        expect(created_notification_locale.object).to eq('notification_locale')
        expect(created_notification_locale.locale).to eq('de')
      end
    end

    context 'when some params are not allowed' do
      it 'returns error' do
        notification_locale = described_class.new(client)

        expect { notification_locale.create({ locale: locale, test: 'test' }) }.to raise_error('ParamNotAllowed')
      end
    end
  end

  describe '#list' do
    let(:response) do
      { body: File.read('./spec/fixtures/notification_locale/list.json'), headers: { 'Content-Type' => 'application/json' } }
    end

    before do
      allow(client.request_client).to receive(:request).and_return(response)
    end

    it 'returns locales' do
      notification_locale = described_class.new(client)
      list_notification_locale = notification_locale.list

      expect(notification_locale).to be_valid
      expect(list_notification_locale.object).to eq('list')
      expect(list_notification_locale.data.size).to eq 1
      expect(list_notification_locale.data.first.locale).to eq(locale)
    end
  end
end
