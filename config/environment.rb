# Load the rails application
require File.expand_path('../application', __FILE__)

S3_URL = 'http://s3.amazon.com/'
S3_ACCESS_KEY = "AKIAJBOJBDC45EBSXYAA"
S3_SECRET     = "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"

APPLICATION_NAME = "tour_builder"
AWS_PLACES_BUCKET = "#{APPLICATION_NAME}_#{Rails.env}"

S3_TOUR_PACK_BASE_URL = "https://s3.amazonaws.com/#{AWS_PLACES_BUCKET}"

S3_POBS_BUCKET_NAME = "pobs_bucket_#{Rails.env}"

TB_SYNC_LOGIN = "TB_SYNC_LKJDFRIKF"
TB_SYNC_PASSWD  = "f#ER@er12$99"

# Initialize the rails application
MarketApi::Application.initialize!

