require 'cirro_io/client/configuration'

RSpec.describe CirroIO::Client::Configuration do
  let(:configuration) { described_class.new }

  it 'assigns app_id' do
    configuration.app_id '12345'

    expect(configuration.app_id).to eq('12345')
  end

  it 'raise exception if app_id is not set' do
    expect { configuration.app_id }.to raise_error('app_id must be defined')
  end

  it 'assigns private_key_path' do
    configuration.private_key_path './storage/cirro.pem'

    expect(configuration.private_key_path).to eq('./storage/cirro.pem')
  end

  it 'raise exception if private_key_path is not set' do
    expect { configuration.private_key_path }.to raise_error('private_key_path must be defined')
  end
end
