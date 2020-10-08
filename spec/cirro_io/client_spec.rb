RSpec.describe CirroIO::Client do
  it 'has a version number' do
    expect(CirroIO::Client::VERSION).not_to be nil
  end

  describe 'configuration' do
    it 'allows to configure client' do
      described_class.configure do |c|
        c.app_id 'WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw'
        c.private_key_path './storage/cirro.pem'
        c.site 'https://api.staging.cirro.io'
      end

      expect(described_class.configuration.app_id).to eq('WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw')
      expect(described_class.configuration.private_key_path).to eq('./storage/cirro.pem')
      expect(described_class.configuration.site).to eq('https://api.staging.cirro.io')

      expect(CirroIO::Client::Base.site).to eq('https://api.staging.cirro.io/v1')
    end
  end
end
