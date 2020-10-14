require 'bundler/setup'
require 'pry'
require 'faker'
require 'cirro_io/client'

# comment out below line and change values below to run test against actual API server
require 'webmock/rspec'

def test_app_id
  'cirro-app-id-development' # Change this to a real one to
end

def test_site
  'http://api.app.localhost:3000'
  # 'https://api.staging.cirro.io' # Change this to a real one to
end

def configure_api_client
  CirroIO::Client.configure do |c|
    c.app_id test_app_id
    c.private_key_path './spec/fixtures/private_key.pem'
    c.site test_site
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
