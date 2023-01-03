RSpec.describe CirroIOV2::Resources::SpaceInvitation do
  let(:site) { 'http://api.cirro.io' }
  let(:id) { '1' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#create' do
    let(:params) do
      {
        "subject": 'A-Team',
        "email": 'new.user@example.com',
        "name": 'New User',
        "inviter_name": 'Generous Inviter',
        "skip_background_check": false,
        "expires_in": 3,
      }
    end

    it 'creates a space_invitation' do
      stub_api = stub_request(:post, "#{site}/v2/space_invitations")
                 .to_return(body: File.read('./spec/fixtures/space_invitation/create.json'))

      space_invitation = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(space_invitation.class).to eq(CirroIOV2::Responses::SpaceInvitationResponse)
      expect(space_invitation.object).to eq('space_invitation')
      expect(space_invitation.token).to be_present
      expect(space_invitation.subject).to eq(params[:subject])
      expect(space_invitation.email).to eq(params[:email])
      expect(space_invitation.name).to eq(params[:name])
      expect(space_invitation.inviter_name).to eq(params[:inviter_name])
      expect(space_invitation.skip_background_check).to eq(params[:skip_background_check])
      expect(space_invitation.expires_at).to eq('2023-05-12T00:00:00Z')
    end
  end

  describe '#expire' do
    it 'expires space_invitations' do
      stub_api = stub_request(:post, "#{site}/v2/space_invitations/#{id}")
                 .to_return(body: File.read('./spec/fixtures/space_invitation/create.json'))

      expired_space_invitations = described_class.new(client).expire(id)

      expect(stub_api).to have_been_made
      expect(expired_space_invitations.class).to eq(CirroIOV2::Responses::SpaceInvitationResponse)
      expect(expired_space_invitations.id).to eq(id)
      expect(expired_space_invitations.object).to eq('space_invitation')
    end
  end
end
