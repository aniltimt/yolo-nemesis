require 'valid_receipt_validator'
MarketApi::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  ValidReceiptValidator.verify_url = "https://sandbox.itunes.apple.com"
  
  AWS::S3::Base.establish_connection!(
    :access_key_id     => 'AKIAJBOJBDC45EBSXYAA', 
    :secret_access_key => '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'
  )
end
ADMIN_LOGIN = 'admin'
ADMIN_PASSWD = '123456'

GOOGLE_PLAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyNqFbfJadlHxDV3aNX28 yUKwtSaH5IEBT3fYryZ9iDfwvniH4ipy598XayBLOh68Q/o/xwFquwJ+2ZCRFdLF Bma3N4kuKac2DhCCE8XGbuRm9H1cdX7Z+H8E7OFveO8H7nAy1LKVOYewetSsho/q hM4uMme6p2jSblIoCq835Ws9zRc1NY+BbDO4mdx9JniJI7C2eQWexMDVYE49keWJ RuqAoqO2y8KIOUtY3gYUgB5sjqSHEfqPRUQ7gHz2olhQXL0sLC/3++U6hCbFvlJe lecBOx66tVtOy8e6E1NdCSZXO5bM1uXqLpCUYo3zofrJR1X9JdGgLTErjNcf5sGX GwIDAQAB"
