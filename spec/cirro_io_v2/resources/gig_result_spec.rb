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

    it 'creates a gig result' do
      stub_api = stub_request(:post, "#{site}/v2/gig_results")
                 .to_return(body: File.read('./spec/fixtures/gig_result/create.json'))

      gig_result = described_class.new(client).create(params)

      expect(stub_api).to have_been_made
      expect(gig_result.class).to eq(CirroIOV2::Responses::GigResultResponse)
      expect(gig_result.object).to eq('gig_result')
      expect(gig_result.title).to eq(params[:title])
      expect(gig_result.user_id).to eq(params[:user_id])
      expect(gig_result.gig_task_id).to eq(params[:gig_task_id])
      expect(gig_result.description).to eq(params[:description])
      expect(gig_result.quantity).to eq(params[:quantity])
      expect(gig_result.multiplier).to eq(params[:multiplier])
      expect(gig_result.delivery_date).to eq(params[:delivery_date])
      expect(gig_result.cost_center_data).to eq(params[:cost_center_data])
      expect(gig_result.cost_center_key).to be_nil
    end
  end

  describe '#list' do
    it 'returns gig results' do
      stub_api = stub_request(:get, "#{site}/v2/gig_results")
                 .to_return(body: File.read('./spec/fixtures/gig_result/list.json'))

      gig_results = described_class.new(client).list

      expect(stub_api).to have_been_made
      expect(gig_results.class).to eq(CirroIOV2::Responses::GigResultListResponse)
      expect(gig_results.object).to eq('list')
      expect(gig_results.data.first.class).to eq(CirroIOV2::Responses::GigResultResponse)
      expect(gig_results.data.first.id).to eq('1')
      expect(gig_results.data.first.object).to eq('gig_result')
      expect(gig_results.data.first.gig_task_id).to eq('1')
      expect(gig_results.data.first.user_id).to eq('1')
    end
  end
end
