require_relative 'lib/cirro_io/client/version'

Gem::Specification.new do |spec|
  spec.name          = "cirro-ruby-client"
  spec.version       = CirroIO::Client::VERSION
  spec.authors       = ["Cirro Dev Team"]
  spec.email         = ["OrgtestIODevelopers@epam.com"]

  spec.summary       = "Ruby client library for Cirro API"
  spec.description   = "Simple wrapper for Cirro API"
  spec.homepage      = "https://cirro.io/api-docs/v1#cirro-api-documentation"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/test-IO/cirro-ruby-client"
  spec.metadata["changelog_uri"] = "https://github.com/test-IO/cirro-ruby-client/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
