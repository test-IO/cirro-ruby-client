RSpec.describe CirroIOV2::Resources::GigResult do
  let(:site) { 'http://api.cirro.io' }
  let(:client) do
    CirroIOV2::Client.new(private_key: File.read('./spec/fixtures/private_key.pem'),
                          client_id: 1,
                          site: site)
  end

  describe '#create' do
    let(:params) do
      {
        gig_task_id: '1',
        user_id: '1',
        title: 'Batman Begins',
        description: "All right, Mr. DeMille, I'm ready for my closeup.",
        quantity: 2,
        multiplier: '1.0',
        delivery_date: '2022-06-13',
        cost_center_data: {
          company: 'Schinner, Brakus and Ortiz',
          inhouse: 'no',
          customer_id: '1234',
          legal_entity: 'GmbH',
        },
      }
    end

    it 'creates a gig time activity' do
      stub_api = stub_request(:post, "#{site}/v2/gig_results")
                 .to_return(body: File.read('./spec/fixtures/gig_result/create.json'))

      payout = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(payout.class).to eq(CirroIOV2::Responses::GigResultResponse)
      expect(payout.object).to eq('gig_result')
      expect(payout.title).to eq(params[:title])
      expect(payout.user_id).to eq(params[:user_id])
      expect(payout.gig_task_id).to eq(params[:gig_task_id])
      expect(payout.description).to eq(params[:description])
      expect(payout.quantity).to eq(params[:quantity])
      expect(payout.multiplier).to eq(params[:multiplier])
      expect(payout.delivery_date).to eq(params[:delivery_date])
      expect(payout.cost_center_data).to eq(params[:cost_center_data])
      expect(payout.cost_center_key).to be_nil
    end
  end
end
