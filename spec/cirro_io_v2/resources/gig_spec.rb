RSpec.describe CirroIOV2::Resources::Gig do
  describe '#create' do
    subject do
      client.Gig.create(gig_params)
    end

    let(:gig) { FactoryBot.create(:gig) }
    let(:gig_params) { gig.to_h.deep_symbolize_keys.except(:id, :object) }
    let(:client) { CirroIOV2::Client.new }

    before do
      allow_any_instance_of(CirroIOV2::RequestClients::Base)
        .to receive(:request)
        .and_return(double(body: gig.to_h))
    end

    it 'sends request' do
      expect_any_instance_of(CirroIOV2::RequestClients::Base)
        .to receive(:request)
        .with(:post, 'gigs', { body: gig_params })
      subject
    end

    it 'returns gig' do
      expect(subject).to eq(gig)
    end
  end
end
