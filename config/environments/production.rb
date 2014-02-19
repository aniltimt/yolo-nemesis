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
  
  ValidReceiptValidator.verify_url = "https://buy.itunes.apple.com"
end

ADMIN_LOGIN = 'admin'
ADMIN_PASSWD = '123456'

GOOGLE_PLAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnZwpY6nLWa6hq5DyJPaiB/vcwPEw9lVYfT/i6zjbjKHrTdr/3B67D9GRiPEPT1WXiWr7aFTYRdbg1ZDq3aiFfd5CL8mRYkCfnb1tuBjfZDnw5hMDTXycYftwNUX6puDAdNvSst4KoqNHpIEjAyb8rFTX6DCbhvYQ7I0uM04HKV7A4VzcZBnz6j9n07S8BSJOxMpWxekJVdbX+FchUlguu68Fgc6e9jUD4kZTZbMVNAiOS83jyMxggNKvdDjtDHEvLdVj7QRvldzTYkz2+o3TXPfN02YhCMp/qXQN5F9l9N6cWLA8ITrMTerVhS9AMC/eHqYWEncw4wGdV9jpKJ80pwIDAQAB"
