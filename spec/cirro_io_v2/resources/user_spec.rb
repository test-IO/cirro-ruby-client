RSpec.describe CirroIOV2::Resources::User do
  describe '#find' do
    subject(:find_user) { client.User.find(id) }

    let(:user) { FactoryBot.create(:user) }
    let(:id) { user.id }
    let(:client) { CirroIOV2::Client.new }

    before { allow(client.request_client).to receive(:request).and_return(OpenStruct.new(body: user.to_h)) }

    it 'sends request' do
      find_user
      expect(client.request_client).to have_received(:request).with(:get, "users/#{id}")
    end

    it 'returns user' do
      expect(find_user).to eq(user)
    end
  end
end
