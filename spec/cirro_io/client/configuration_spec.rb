RSpec.describe CirroIO::Client::Configuration do
  let(:configuration) { described_class.new }

  it 'raise exception if app_id is not set' do
    expect { configuration.app_id }.to raise_error('app_id must be defined')
  end

  it 'raise exception if private_key_path is not set' do
    expect { configuration.private_key_path }.to raise_error('private_key_path must be defined')
  end

  it 'raise exception if site is not set' do
    expect { configuration.site }.to raise_error('site must be defined')
  end

  it 'returns api version' do
    expect(configuration.api_version).to eq('v1')
  end
end
