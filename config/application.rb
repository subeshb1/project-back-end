# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
# require "active_model/railtie"
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'active_storage/engine'
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BackEnd
  # :nodoc:
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Dir[Rails.root.join('lib', '**', '*.rb').to_s].each { |f| require(f) }

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    Dir["#{Rails.root}/app/middleware/*.rb"].each { |file| require(file) }
    Dir[Rails.root.join('app', 'middleware', '*.rb').to_s].each { |f| require(f) }
    Dir[Rails.root.join('app', 'error_objects', '*.rb').to_s].each { |f| require(f) }
    Dir[Rails.root.join('app', 'form_objects', '**', '*.rb').to_s].sort.each do |file|
      require(file)
    end
    Dir[Rails.root.join('app', 'service_objects', '*.rb').to_s].each { |f| require(f) }
    # Configuration for production, staging and test environment.

    # Code is not reloaded between requests.
    config.cache_classes = true

    # Configuration for production, staging environment.

    # Eager load code on boot. This eager loads most of Rails and
    # your application in memory, allowing both threaded web servers
    # and those relying on copy on write to perform better.
    # Rake tasks automatically ignore this option for performance.
    config.eager_load = true

    # Full error reports are disabled and caching is turned on.
    config.consider_all_requests_local       = false
    config.action_controller.perform_caching = true

    config.api_only = true
    config.middleware.insert_after Rack::Runtime, CatchJsonParseErrors

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post options]
      end
    end
  end
end
