require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SlotApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.i18n.default_locale = :ja
    # config.time_zone = 'Asia/Tokyo'
    # config.time_zone = 'UTC'
    # config.active_record.default_timezone = 'JST'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
  end
end
