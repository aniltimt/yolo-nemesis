require 'valid_receipt_validator'
MarketApi::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  ValidReceiptValidator.verify_url = "https://sandbox.itunes.apple.com"
end

ADMIN_LOGIN = 'admin'
ADMIN_PASSWD = '123456'

GOOGLE_PLAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyNqFbfJadlHxDV3aNX28 yUKwtSaH5IEBT3fYryZ9iDfwvniH4ipy598XayBLOh68Q/o/xwFquwJ+2ZCRFdLF Bma3N4kuKac2DhCCE8XGbuRm9H1cdX7Z+H8E7OFveO8H7nAy1LKVOYewetSsho/q hM4uMme6p2jSblIoCq835Ws9zRc1NY+BbDO4mdx9JniJI7C2eQWexMDVYE49keWJ RuqAoqO2y8KIOUtY3gYUgB5sjqSHEfqPRUQ7gHz2olhQXL0sLC/3++U6hCbFvlJe lecBOx66tVtOy8e6E1NdCSZXO5bM1uXqLpCUYo3zofrJR1X9JdGgLTErjNcf5sGX GwIDAQAB"
