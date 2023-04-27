RSpec.describe CirroIOV2::Resources::GigInvitation do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end
  let(:id) { '1' }

  describe '#list' do
    it 'returns gig_invitations' do
      stub_api = stub_request(:get, "#{site}/v2/gig_invitations")
                 .to_return(body: File.read('./spec/fixtures/gig_invitation/list.json'))

      gig_invitations = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(gig_invitations.class).to eq(CirroIOV2::Responses::GigInvitationListResponse)
      expect(gig_invitations.object).to eq('list')
      expect(gig_invitations.data.first.class).to eq(CirroIOV2::Responses::GigInvitationResponse)
      expect(gig_invitations.data.first.id).to eq('45')
      expect(gig_invitations.data.first.object).to eq('gig_invitation')
      expect(gig_invitations.data.first.status).to eq('pending')
      expect(gig_invitations.data.first.gig_id).to eq('1')
      expect(gig_invitations.data.first.user_id).to eq('1')
      expect(gig_invitations.data.first.no_reward).to eq(false)
      expect(gig_invitations.data.first.epam_bench_status).to eq('extra_mile')
    end
  end

  describe '#accept' do
    it 'accepts gig_invitations' do
      stub_api = stub_request(:post, "#{site}/v2/gig_invitations/#{id}/accept")
                 .to_return(body: File.read('./spec/fixtures/gig_invitation/accept.json'))

      accepted_gig_invitation = described_class.new(client).accept(id)

      expect(stub_api).to have_been_made
      expect(accepted_gig_invitation.class).to eq(CirroIOV2::Responses::GigInvitationResponse)
      expect(accepted_gig_invitation.id).to eq(id)
      expect(accepted_gig_invitation.object).to eq('gig_invitation')
      expect(accepted_gig_invitation.status).to eq('accepted')
      expect(accepted_gig_invitation.gig_id).to eq('1')
      expect(accepted_gig_invitation.user_id).to eq('1')
      expect(accepted_gig_invitation.no_reward).to eq(false)
      expect(accepted_gig_invitation.epam_bench_status).to eq('extra_mile')
    end

    it 'accepts `no_reward` as param' do
      stub_api = stub_request(:post, "#{site}/v2/gig_invitations/#{id}/accept")
                 .with(body: { no_reward: true })
                 .to_return(body: File.read('./spec/fixtures/gig_invitation/accept.json'))

      described_class.new(client).accept(id, no_reward: true)

      expect(stub_api).to have_been_made
    end

    context 'when testing response' do
      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/gig_invitation/accept.json')) }
      let(:request_url) { "#{site}/v2/gig_invitations/#{id}/accept" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'status' => 'aasm_state'
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::GigInvitationResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      subject { described_class.new(client).accept(id, no_reward: true) }

      include_examples 'responses'
    end
  end

  describe '#reject' do
    it 'rejects gig_invitations' do
      stub_api = stub_request(:post, "#{site}/v2/gig_invitations/#{id}/reject")
                 .to_return(body: File.read('./spec/fixtures/gig_invitation/reject.json'))

      accepted_gig_invitation = described_class.new(client).reject(id)

      expect(stub_api).to have_been_made
      expect(accepted_gig_invitation.class).to eq(CirroIOV2::Responses::GigInvitationResponse)
      expect(accepted_gig_invitation.id).to eq(id)
      expect(accepted_gig_invitation.object).to eq('gig_invitation')
      expect(accepted_gig_invitation.status).to eq('rejected')
      expect(accepted_gig_invitation.gig_id).to eq('1')
      expect(accepted_gig_invitation.user_id).to eq('1')
      expect(accepted_gig_invitation.no_reward).to eq(false)
      expect(accepted_gig_invitation.epam_bench_status).to eq('on_bench')
    end
  end

  describe '#expire' do
    it 'expires gig_invitations' do
      stub_api = stub_request(:post, "#{site}/v2/gig_invitations/#{id}/expire")
                 .to_return(body: File.read('./spec/fixtures/gig_invitation/expire.json'))

      accepted_gig_invitation = described_class.new(client).expire(id)

      expect(stub_api).to have_been_made
      expect(accepted_gig_invitation.class).to eq(CirroIOV2::Responses::GigInvitationResponse)
      expect(accepted_gig_invitation.id).to eq(id)
      expect(accepted_gig_invitation.object).to eq('gig_invitation')
      expect(accepted_gig_invitation.status).to eq('expired')
      expect(accepted_gig_invitation.gig_id).to eq('1')
      expect(accepted_gig_invitation.user_id).to eq('1')
      expect(accepted_gig_invitation.no_reward).to eq(false)
      expect(accepted_gig_invitation.epam_bench_status).to eq('on_bench')
    end
  end

  describe '#reset' do
    it 'reset gig_invitations' do
      stub_api = stub_request(:post, "#{site}/v2/gig_invitations/#{id}/reset")
                 .to_return(body: File.read('./spec/fixtures/gig_invitation/reset.json'))

      accepted_gig_invitation = described_class.new(client).reset(id)

      expect(stub_api).to have_been_made
      expect(accepted_gig_invitation.class).to eq(CirroIOV2::Responses::GigInvitationResponse)
      expect(accepted_gig_invitation.id).to eq(id)
      expect(accepted_gig_invitation.object).to eq('gig_invitation')
      expect(accepted_gig_invitation.status).to eq('pending')
      expect(accepted_gig_invitation.gig_id).to eq('1')
      expect(accepted_gig_invitation.user_id).to eq('1')
      expect(accepted_gig_invitation.no_reward).to eq(false)
      expect(accepted_gig_invitation.epam_bench_status).to eq('extra_mile')
    end
  end
end
