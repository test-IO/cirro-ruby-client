RSpec.describe CirroIOV2::Resources::Payout do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#create' do
    let(:params) do
      {
        amount: 1000,
        title: 'The Golden Bowl',
        description: 'Language designers want to design the perfect language.',
        billing_date: '2022-06-05',
        cost_center_key: 'EPM-CRWD',
        user_id: 1,
      }
    end

    it 'creates a payout' do
      stub_api = stub_request(:post, "#{site}/v2/payouts")
                 .to_return(body: File.read('./spec/fixtures/payout/create.json'))

      payout = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(payout.class).to eq(CirroIOV2::Responses::PayoutResponse)
      expect(payout.object).to eq('payout')
      expect(payout.title).to eq(params[:title])
      expect(payout.user_id).to eq(params[:user_id])
      expect(payout.amount).to eq(params[:amount])
      expect(payout.description).to eq(params[:description])
      expect(payout.billing_date).to eq(params[:billing_date])
      expect(payout.cost_center_key).to eq(params[:cost_center_key])
      expect(payout.cost_center_data).to be_nil
    end
  end
end
