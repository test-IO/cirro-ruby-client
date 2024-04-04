RSpec.describe CirroIOV2::Resources::User do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site:)
  end
  let(:user_id) { '13' }
  let(:params) do
    {
      "locale": 'de',
      "topics": [
        {
          "id": '1',
          "preferences": {
            "email": 'immediately',
          },
        },
      ],
    }
  end

  describe '#create' do
    let(:params) do
      {
        "first_name": 'Maynard',
        "last_name": 'Keenan',
        "email": 'mjk@test.io',
        "time_zone": 'Berlin',
        "birthday": '1975-11-22',
        "country_code": 'DE',
        "password": '@123456abc@',
      }
    end

    it 'creates user with params' do
      stub_api = stub_request(:post, "#{site}/v2/users")
                 .to_return(body: File.read('./spec/fixtures/user/create.json'))

      user = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(user.class).to eq(CirroIOV2::Responses::UserResponse)
      expect(user.object).to eq('user')
      expect(user.first_name).to eq(params[:first_name])
      expect(user.last_name).to eq(params[:last_name])
      expect(user.time_zone).to eq(params[:time_zone])
      expect(user.country_code).to eq(params[:country_code])
      expect(user.birthday).to eq(params[:birthday])
    end

    it 'creates user without params' do
      stub_api = stub_request(:post, "#{site}/v2/users")
                 .to_return(body: File.read('./spec/fixtures/user/create.json'))

      user = described_class.new(client).create

      expect(stub_api).to have_been_made
      expect(user.class).to eq(CirroIOV2::Responses::UserResponse)
      expect(user.object).to eq('user')
    end
  end

  describe '#find' do
    it 'finds user' do
      stub_api = stub_request(:get, "#{site}/v2/users/#{user_id}")
                 .to_return(body: File.read('./spec/fixtures/user/find.json'))

      user = described_class.new(client).find(user_id)

      expect(stub_api).to have_been_made
      expect(user.class).to eq(CirroIOV2::Responses::UserResponse)
      expect(user.id).to eq(user_id)
      expect(user.object).to eq('user')
      expect(user.first_name).to eq('Grazyna')
      expect(user.epam[:id]).to eq('12345')
      expect(user.anonymous_email).to eq('anonymous_email@some.mail')
    end

    it 'correctly sets attributes when any attribute is nil' do
      fixture_body = JSON.parse(File.read('./spec/fixtures/user/find.json'))
      fixture_body['epam'] = nil
      stub_request(:get, "#{site}/v2/users/#{user_id}").to_return(body: fixture_body.to_json)

      user = described_class.new(client).find(user_id)

      expect(user.epam).to be_nil
      expect(user.worker[:billable]).to eq(false)
    end

    context 'when testing response' do
      subject { described_class.new(client).find(user_id) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/user/find.json')) }
      let(:request_url) { "#{site}/v2/users/#{user_id}" }
      let(:request_action) { :get }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'anonymous_email' => 'email',
          'first_name' => 'firstname',
          'worker' => 'something_else',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::UserResponse }
      let(:expected_response) do
        {
          id: user_id,
          object: 'user',
          last_name: fixture_body['last_name'],
          time_zone: fixture_body['time_zone'],
          birthday: fixture_body['birthday'],
          country_code: fixture_body['country_code'],
        }
      end

      include_examples 'responses'
    end
  end

  describe '#notification_preferences' do
    it 'creates notification_preferences' do
      stub_api = stub_request(:post, "#{site}/v2/users/#{user_id}/notification_preferences")
                 .to_return(body: File.read('./spec/fixtures/user/notification_preferences.json'))

      notification_preferences = described_class.new(client).notification_preferences(user_id, params)

      expect(stub_api).to have_been_made
      expect(notification_preferences.class).to eq(CirroIOV2::Responses::UserNotificationPreferenceResponse)
      expect(notification_preferences.object).to eq('notification_preference')
      expect(notification_preferences.locale).to eq('de')
      expect(notification_preferences.topics.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceListResponse)
      expect(notification_preferences.topics.data.first.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceResponse)
    end
  end

  describe '#worker' do
    let(:params) do
      {
        document: {
          age: 42,
          foo: {
            bar: '42',
          },
        },
      }
    end

    it 'update/create worker document' do
      stub_api = stub_request(:post, "#{site}/v2/users/#{user_id}/worker")
                 .to_return(body: File.read('./spec/fixtures/user/worker.json'))

      user = described_class.new(client).worker(user_id, params)

      expect(stub_api).to have_been_made
      expect(user.class).to eq(CirroIOV2::Responses::UserResponse)
      expect(user.id).to eq(user_id)
      expect(user.object).to eq('user')
      expect(user.first_name).to eq('Grazyna')
      expect(user.worker[:document]).to eq(params[:document])
    end
  end

  describe '#notification_preference' do
    it 'gets the notification preference for a user' do
      stub_api = stub_request(:get, "#{site}/v2/users/#{user_id}/notification_preference")
                 .to_return(body: File.read('./spec/fixtures/user/notification_preferences.json')) # same response as create

      notification_preference = described_class.new(client).notification_preference(user_id)

      expect(stub_api).to have_been_made
      expect(notification_preference.class).to eq(CirroIOV2::Responses::UserNotificationPreferenceResponse)
      expect(notification_preference.object).to eq('notification_preference')
      expect(notification_preference.locale).to eq('de')
      expect(notification_preference.topics.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceListResponse)
      expect(notification_preference.topics.data.first.class).to eq(CirroIOV2::Responses::NotificationTopicPreferenceResponse)
    end

    context 'when testing response' do
      subject { described_class.new(client).notification_preference(user_id) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/user/notification_preferences.json')) }
      let(:request_url) { "#{site}/v2/users/#{user_id}/notification_preference" }
      let(:request_action) { :get }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'topics' => 'channel',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::UserNotificationPreferenceResponse }
      let(:expected_response) do
        {
          id: '1',
          object: 'notification_preference',
          locale: fixture_body['locale'],
        }
      end

      include_examples 'responses'
    end
  end

  describe '#invitation_attempt' do
    let(:params) do
      {
        gig_ids: [2, 3],
        max_amount: 2,
      }
    end

    it 'creates invitation_attempt' do
      stub_api = stub_request(:post, "#{site}/v2/users/#{user_id}/invitation_attempt")
                 .to_return(body: File.read('./spec/fixtures/user/invitation_attempt.json'))

      invitation_attempt = described_class.new(client).invitation_attempt(user_id, params)

      expect(stub_api).to have_been_made
      expect(invitation_attempt.class).to eq(CirroIOV2::Responses::UserInvitationAttemptResponse)
      expect(invitation_attempt.object).to eq('invitation_attempt')
      expect(invitation_attempt.payload).to eq(params)
      expect(invitation_attempt.gig_ids).to eq([2, 3])
      expect(invitation_attempt.app_worker_id).to eq(1)
    end
  end
end
