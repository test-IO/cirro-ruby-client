RSpec.describe CirroIOV2::Resources::Payout do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site:)
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
      expect(payout.user_id).to eq(params[:user_id].to_s)
      expect(payout.amount).to eq(params[:amount])
      expect(payout.description).to eq(params[:description])
      expect(payout.billing_date).to eq(params[:billing_date])
      expect(payout.cost_center_key).to eq(params[:cost_center_key])
      expect(payout.cost_center_data).to be_nil
    end

    context 'when testing response' do
      subject { described_class.new(client).create(params) }

      let(:fixture_body) { JSON.parse(File.read('./spec/fixtures/payout/create.json')) }
      let(:request_url) { "#{site}/v2/payouts" }
      let(:request_action) { :post }
      let(:keys) { fixture_body.keys }
      let(:replace_keys) do
        {
          'title' => 'name',
          'billing_date' => 'delivery_date',
        }
      end
      let(:expected_response_class) { CirroIOV2::Responses::PayoutResponse }
      let(:expected_response) do
        fixture_body.excluding(*replace_keys.values)
      end

      include_examples 'responses'
    end
  end

  describe '#list' do
    it 'returns gig results' do
      stub_api = stub_request(:get, "#{site}/v2/payouts")
                 .to_return(body: File.read('./spec/fixtures/payout/list.json'))

      payouts = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(payouts.class).to eq(CirroIOV2::Responses::PayoutListResponse)
      expect(payouts.object).to eq('list')
      expect(payouts.data.first.class).to eq(CirroIOV2::Responses::PayoutResponse)
      expect(payouts.data.first.id).to eq('1')
      expect(payouts.data.first.object).to eq('payout')
      expect(payouts.data.first.reference_id).to eq('42')
      expect(payouts.data.first.reference_type).to eq('Gig')
      expect(payouts.data.first.user_id).to eq('1')
    end
  end

  describe '#delete' do
    let(:id) { '1' }

    it 'deletes a payout' do
      stub_api = stub_request(:delete, "#{site}/v2/payouts/#{id}")
                 .to_return(body: File.read('./spec/fixtures/payout/delete.json'))

      deleted_payout = described_class.new(client).delete(id)

      expect(stub_api).to have_been_made
      expect(deleted_payout.class).to eq(CirroIOV2::Responses::PayoutDeleteResponse)
      expect(deleted_payout.id).to eq(id)
      expect(deleted_payout.object).to eq('payout')
      expect(deleted_payout.deleted).to eq(true)
    end
  end
end
