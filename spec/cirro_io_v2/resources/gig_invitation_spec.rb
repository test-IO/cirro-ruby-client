RSpec.describe CirroIOV2::Resources::GigInvitation do
  let(:client) { CirroIOV2::Client.new }

  describe '#list' do
    subject do
      client.GigInvitation.list(params)
    end

    let(:gig_invitations_list) { FactoryBot.create(:gig_invitations_list) }
    let(:params) do
      {
        user_id: SecureRandom.uuid,
        gig_id: SecureRandom.uuid,
        limit: rand(1..10),
        before: SecureRandom.uuid,
        after: SecureRandom.uuid,
        status: 'accepted'
      }
    end

    before do
      allow_any_instance_of(CirroIOV2::RequestClients::Base)
        .to receive(:request)
        .and_return(double(body: gig_invitations_list.to_h))
    end

    it 'sends request' do
      expect_any_instance_of(CirroIOV2::RequestClients::Base)
        .to receive(:request)
        .with(:get, "gig_invitations", { params: params })
      subject
    end

    it 'returns gig invitation' do
      expect(subject).to eq(gig_invitations_list)
    end
  end

  describe '#accept' do
    subject do
      client.GigInvitation.accept(id)
    end

    let(:gig_invitation) { FactoryBot.create(:gig_invitation) }
    let(:id) { gig_invitation.id }

    before do
      allow_any_instance_of(CirroIOV2::RequestClients::Base)
        .to receive(:request)
        .and_return(double(body: gig_invitation.to_h))
    end

    it 'sends request' do
      expect_any_instance_of(CirroIOV2::RequestClients::Base).to receive(:request).with(:post, "gig_invitations/#{id}/accept")
      subject
    end

    it 'returns gig invitation' do
      expect(subject).to eq(gig_invitation)
    end
  end
end
