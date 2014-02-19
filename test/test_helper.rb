ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include Factory::Syntax::Methods
end

DatabaseCleaner.strategy = :truncation
