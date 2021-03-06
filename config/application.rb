require_relative 'boot'

require 'rails/all'
Dir['./lib/idempotent_request/*.rb'].each { |f| require f }

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Auctionz
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Use Idempotent keys stored in a database
    # config.middleware.use IdempotentRequest::Database

    # Use Idempotent keys stored in a YAML::Store
    # config.middleware.use IdempotentRequest::YStore

    # Use Idempotent keys stored in Redis
    config.middleware.use IdempotentRequest::Redis
  end
end
