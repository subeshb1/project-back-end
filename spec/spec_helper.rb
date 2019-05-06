# frozen_string_literal: true
require 'shoulda/matchers'
require 'rubycritic/cli/application'
Dir["#{Rails.root}/spec/support/**/*.rb"].each { |f| require(f) }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.color = true
  config.formatter = :documentation
  config.order = :random
  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.after(:suite) do
    if ENV['CODE_REVIEW']
      RubyCritic::Cli::Application.new(['--no-browser']).execute
    end
  end
end
