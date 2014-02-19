require 'valid_receipt_validator'
MarketApi::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  ValidReceiptValidator.verify_url = "https://sandbox.itunes.apple.com"
end

ADMIN_LOGIN = 'admin'
ADMIN_PASSWD = '123456'

GOOGLE_PLAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyNqFbfJadlHxDV3aNX28 yUKwtSaH5IEBT3fYryZ9iDfwvniH4ipy598XayBLOh68Q/o/xwFquwJ+2ZCRFdLF Bma3N4kuKac2DhCCE8XGbuRm9H1cdX7Z+H8E7OFveO8H7nAy1LKVOYewetSsho/q hM4uMme6p2jSblIoCq835Ws9zRc1NY+BbDO4mdx9JniJI7C2eQWexMDVYE49keWJ RuqAoqO2y8KIOUtY3gYUgB5sjqSHEfqPRUQ7gHz2olhQXL0sLC/3++U6hCbFvlJe lecBOx66tVtOy8e6E1NdCSZXO5bM1uXqLpCUYo3zofrJR1X9JdGgLTErjNcf5sGX GwIDAQAB"
GOOGLE_PLAY_PRIVATE_KEY = "MIIEowIBAAKCAQEAyNqFbfJadlHxDV3aNX28yUKwtSaH5IEBT3fYryZ9iDfwvniH 4ipy598XayBLOh68Q/o/xwFquwJ+2ZCRFdLFBma3N4kuKac2DhCCE8XGbuRm9H1c dX7Z+H8E7OFveO8H7nAy1LKVOYewetSsho/qhM4uMme6p2jSblIoCq835Ws9zRc1 NY+BbDO4mdx9JniJI7C2eQWexMDVYE49keWJRuqAoqO2y8KIOUtY3gYUgB5sjqSH EfqPRUQ7gHz2olhQXL0sLC/3++U6hCbFvlJelecBOx66tVtOy8e6E1NdCSZXO5bM 1uXqLpCUYo3zofrJR1X9JdGgLTErjNcf5sGXGwIDAQABAoIBAGupPmZNxxGvII+y o/mSOXSEC+Y+Dg982u/25K4V6qnumlvujZ+8czU4zvu8JrazrOSfKjqI1uYBE2+Z Xzuca8Hfowvgu17WY1IspRzmIVRll44r+Dh+02Ww6Dn1KORg9BZqC8UZKIXa5s0g XI4QbHvdbMPV+CYuOMWrwgzgGQ0eeEvtctlXkQHbQP6dAUlFpMHwdvIeCVHCL2em fBgbQKDE67wNKjaJmQjKPD/HQSvrgjXlqekSBv9CaltcHkUycQh9BMuY07WesBfY 7nag24Q7CKs+zc9xwOUlWJ2Q0lLHSyvVJop/gaDD2gTSowIDDZ+ih6YeYs9IyZaj fT5HMCECgYEA8NR3PbtIO5f7hfMJSezVeqXl1Sx10FGutta21BcnxBlxxDmzp2q6 RKTVOZuw58lTWb8cE5NtbHhA18MuEif8TUzsYC52cogcX+MnZ3YvvdVaRm+g5+IO S7RarLfZxayjwP+W6AS+cfORQaTLDrjd8OMuB+2cHx6ujwiHzCs8J6sCgYEA1YFp ZmxGt2SlqdLr1ROtYBlZKR6k0BrwtIsFRZeETbM6dDatVZ/slQk0Opn3trq1fLdE TPBB6iVzUAztWH+wShQI3xvcZ2rkGpJ5OBWUfi/vHFPontAvW2iXceNUzh1eCnBS Koj1e/lmVSJHf1dMUXeAyh/RVscGAww93gU5HlECgYBYoWjM4DriK7nWfy4g9bdP LvTZskYdh6IsCfM5NNhetBqJY875Qy8QCjWqwOCnPRGeytWTYsN3kv4SKfOvnOWe sTug3hibZ/pBU8Dxs644R+e0Wmq2TByEwfhI7lSIClQtuCKaevx3xXLk3LgaT/Dm MUWEh27YiRsm6rXHbvXxhwKBgQCWj9RMLj8QRSGuSNeWQ3IYOsftf3aqatUj/IWT Ne5O/P1Txtslbsnfr8XtLXbKnZAuiu7XcvaIsDBJW1Rk/GbNVqOK8pLTO0Xwlyp0 qoM1GYh9aY65sAY1Z+Sko7PCRmNy6RKIfFzhOFc54hqZam6fZK6l2xo9H8zViWR3 lSdagQKBgAJ9vv4QRrS8XTYEQedERI9zXtjP5Krd0wQ3oDPtR2wARjLkW63ycNRB +bIgIzi86IMBuSThNskSJX3t69fcQEIiHUQ7scOALC2KWEy2db8QYrfmL1SGsttZ 0ykYg+B0bFz3Qoi7x6F5VaEyjY8KCTeCEFVMIFqA2GoMF095xgxm"
