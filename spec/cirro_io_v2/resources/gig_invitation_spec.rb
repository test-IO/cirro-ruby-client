RSpec.describe CirroIOV2::Resources::GigInvitation do
  let(:client) { CirroIOV2::Client.new }

  describe '#list' do
    subject(:list_gigs) { client.GigInvitation.list(params) }

    let(:gig_invitations_list) { FactoryBot.create(:gig_invitations_list).to_h }
    let(:gig_invitations_list_responce) do
      gig_invitations_list_responce = OpenStruct.new(body: gig_invitations_list.to_h)
      gig_invitations_list_responce.body[:data].map!(&:to_h)
      gig_invitations_list_responce
    end

    let(:params) do
      {
        user_id: SecureRandom.uuid,
        gig_id: SecureRandom.uuid,
        limit: rand(1..10),
        before: SecureRandom.uuid,
        after: SecureRandom.uuid,
        status: 'accepted',
      }
    end

    before do
      allow(client.request_client).to receive(:request).and_return(gig_invitations_list_responce)
      expect_any_instance_of(described_class).to receive(:validate_list_params)
    end

    it 'sends request' do
      list_gigs
      expect(client.request_client).to have_received(:request).with(:get, 'gig_invitations', { params: params })
    end

    it 'returns gig invitation' do
      expect(list_gigs).to be_a(Struct)
      expect(list_gigs.to_h.excluding(:data)).to eq(gig_invitations_list.excluding(:data))
      expect(list_gigs.to_h[:data].map!(&:to_h)).to eq(gig_invitations_list[:data])
    end
  end

  describe '#accept' do
    subject(:accept_gig) { client.GigInvitation.accept(id) }

    let(:gig_invitation) { FactoryBot.create(:gig_invitation) }
    let(:id) { gig_invitation.id }

    before { allow(client.request_client).to receive(:request).and_return(OpenStruct.new(body: gig_invitation.to_h)) }

    it 'sends request' do
      accept_gig
      expect(client.request_client).to have_received(:request).with(:post, "gig_invitations/#{id}/accept")
    end

    it 'returns gig invitation' do
      expect(accept_gig).to be_a(Struct)
      expect(accept_gig.to_h).to eq(gig_invitation.to_h)
    end
  end
end
