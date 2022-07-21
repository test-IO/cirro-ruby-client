RSpec.describe CirroIOV2::Resources::User do
  describe '#find' do
    subject do
      client.User.find(id)
    end

    let(:user) { FactoryBot.create(:user) }
    let(:id) { user.id }
    let(:client) { CirroIOV2::Client.new }

    before do
      allow_any_instance_of(CirroIOV2::RequestClients::Base)
        .to receive(:request)
        .and_return(double(body: user.to_h))
    end

    it 'sends request' do
      expect_any_instance_of(CirroIOV2::RequestClients::Base).to receive(:request).with(:get, "users/#{id}")
      subject
    end

    it 'returns user' do
      expect(subject).to eq(user)
    end
  end
end
