require 'simplecov'
require 'simplecov_json_formatter'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::JSONFormatter, SimpleCov::Formatter::HTMLFormatter])
SimpleCov.minimum_coverage 10

# Ignore coverage when generating swagger docs
unless RSpec.configuration.dry_run?
  SimpleCov.start 'rails' do
    add_group 'Models', 'app/models'
    add_filter %w[spec/]
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
