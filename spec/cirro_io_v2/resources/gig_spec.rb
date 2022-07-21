RSpec.describe CirroIOV2::Resources::Gig do
  describe '#create' do
    subject(:create_gig) { client.Gig.create(gig_params) }

    let(:gig) { FactoryBot.create(:gig) }
    let(:gig_params) { gig.to_h.deep_symbolize_keys.except(:id, :object) }
    let(:client) { CirroIOV2::Client.new }

    before { allow(client.request_client).to receive(:request).and_return(OpenStruct.new(body: gig.to_h)) }

    it 'sends request' do
      create_gig
      expect(client.request_client).to have_received(:request).with(:post, 'gigs', { body: gig_params })
    end

    it 'returns gig' do
      expect(create_gig).to eq(gig)
    end
  end
end
