require 'base64'

module ReceiptHelper
  def receipt(product_id)
    {
      :quantity                     => 1,
      :product_id                   => product_id,
      :transaction_id               => 10000001,
      :purchase_date                => '2011-09-06 12:11:06 UTC',
      :app_item_id                  => 10023,
      :version_external_identifier  => '1.0',
      :bid                          => 'com.df.test',
      :bvrs                         => '1.0'
    }
  end
  
  def receipt_encoded(product_id)
    Base64.encode64(receipt(product_id).to_json)
  end
  
  # Product ID: 45
  def receipt_from_ios
    "ewoJInNpZ25hdHVyZSIgPSAiQXJwcTVZeEZyZFNoSWd3T2FCZ09HY2tVeTF5NTIvVjZ1MGh3Q2djSjhoSDhCWFVzWUtUUklIQzBCbUl3WjliNGZvd3RxZ1h3OEpVQm5tc1ppNVczd1hvRXFKSG54MUpseExaUTBJa1Rqc09sTUkrZ3B1czlBM1FhU1UwRVRIbWhUWDJkT3NuZ1BSVTBwNGE4UjBaZXoxVFZySUZJQlJybmdmTjI1cy9BTGFNVkFBQURWekNDQTFNd2dnSTdvQU1DQVFJQ0NHVVVrVTNaV0FTMU1BMEdDU3FHU0liM0RRRUJCUVVBTUg4eEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUtEQXBCY0hCc1pTQkpibU11TVNZd0pBWURWUVFMREIxQmNIQnNaU0JEWlhKMGFXWnBZMkYwYVc5dUlFRjFkR2h2Y21sMGVURXpNREVHQTFVRUF3d3FRWEJ3YkdVZ2FWUjFibVZ6SUZOMGIzSmxJRU5sY25ScFptbGpZWFJwYjI0Z1FYVjBhRzl5YVhSNU1CNFhEVEE1TURZeE5USXlNRFUxTmxvWERURTBNRFl4TkRJeU1EVTFObG93WkRFak1DRUdBMVVFQXd3YVVIVnlZMmhoYzJWU1pXTmxhWEIwUTJWeWRHbG1hV05oZEdVeEd6QVpCZ05WQkFzTUVrRndjR3hsSUdsVWRXNWxjeUJUZEc5eVpURVRNQkVHQTFVRUNnd0tRWEJ3YkdVZ1NXNWpMakVMTUFrR0ExVUVCaE1DVlZNd2daOHdEUVlKS29aSWh2Y05BUUVCQlFBRGdZMEFNSUdKQW9HQkFNclJqRjJjdDRJclNkaVRDaGFJMGc4cHd2L2NtSHM4cC9Sd1YvcnQvOTFYS1ZoTmw0WElCaW1LalFRTmZnSHNEczZ5anUrK0RyS0pFN3VLc3BoTWRkS1lmRkU1ckdYc0FkQkVqQndSSXhleFRldngzSExFRkdBdDFtb0t4NTA5ZGh4dGlJZERnSnYyWWFWczQ5QjB1SnZOZHk2U01xTk5MSHNETHpEUzlvWkhBZ01CQUFHamNqQndNQXdHQTFVZEV3RUIvd1FDTUFBd0h3WURWUjBqQkJnd0ZvQVVOaDNvNHAyQzBnRVl0VEpyRHRkREM1RllRem93RGdZRFZSMFBBUUgvQkFRREFnZUFNQjBHQTFVZERnUVdCQlNwZzRQeUdVakZQaEpYQ0JUTXphTittVjhrOVRBUUJnb3Foa2lHOTJOa0JnVUJCQUlGQURBTkJna3Foa2lHOXcwQkFRVUZBQU9DQVFFQUVhU2JQanRtTjRDL0lCM1FFcEszMlJ4YWNDRFhkVlhBZVZSZVM1RmFaeGMrdDg4cFFQOTNCaUF4dmRXLzNlVFNNR1k1RmJlQVlMM2V0cVA1Z204d3JGb2pYMGlreVZSU3RRKy9BUTBLRWp0cUIwN2tMczlRVWU4Y3pSOFVHZmRNMUV1bVYvVWd2RGQ0TndOWXhMUU1nNFdUUWZna1FRVnk4R1had1ZIZ2JFL1VDNlk3MDUzcEdYQms1MU5QTTN3b3hoZDNnU1JMdlhqK2xvSHNTdGNURXFlOXBCRHBtRzUrc2s0dHcrR0szR01lRU41LytlMVFUOW5wL0tsMW5qK2FCdzdDMHhzeTBiRm5hQWQxY1NTNnhkb3J5L0NVdk02Z3RLc21uT09kcVRlc2JwMGJzOHNuNldxczBDOWRnY3hSSHVPTVoydG04bnBMVW03YXJnT1N6UT09IjsKCSJwdXJjaGFzZS1pbmZvIiA9ICJld29KSW1sMFpXMHRhV1FpSUQwZ0lqUTJPVGt3TnpJek5pSTdDZ2tpYjNKcFoybHVZV3d0ZEhKaGJuTmhZM1JwYjI0dGFXUWlJRDBnSWpFd01EQXdNREF3TURrek1URXhOVGdpT3dvSkluQjFjbU5vWVhObExXUmhkR1VpSUQwZ0lqSXdNVEV0TVRBdE1ETWdNVEk2TkRjNk5ETWdSWFJqTDBkTlZDSTdDZ2tpY0hKdlpIVmpkQzFwWkNJZ1BTQWlORFVpT3dvSkluUnlZVzV6WVdOMGFXOXVMV2xrSWlBOUlDSXhNREF3TURBd01EQTVNekV4TVRVNElqc0tDU0p4ZFdGdWRHbDBlU0lnUFNBaU1TSTdDZ2tpYjNKcFoybHVZV3d0Y0hWeVkyaGhjMlV0WkdGMFpTSWdQU0FpTWpBeE1TMHhNQzB3TXlBeE1qbzBOem8wTXlCRmRHTXZSMDFVSWpzS0NTSmlhV1FpSUQwZ0ltTnZiUzVrYVdkcGRHRnNabTl2ZEhOMFpYQnpMbVJwWjJsMFlXeG1iMjkwYzNSbGNITXVhVzVoY0hCMFpYTjBhVzVuSWpzS0NTSmlkbkp6SWlBOUlDSXdMamRpTWlJN0NuMD0iOwoJImVudmlyb25tZW50IiA9ICJTYW5kYm94IjsKCSJwb2QiID0gIjEwMCI7Cgkic2lnbmluZy1zdGF0dXMiID0gIjAiOwp9"
  end
  
  def successful_receipt_validation_stub
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post '/verifyReceipt' do |env|
        [
          200,
          {'Content-Type' => 'application/json'},
          {
            :status => 0,
            :receipt => ActiveSupport::JSON.decode(env[:body])['receipt-data']
          }.to_json
        ]
      end
    end
  end
  
  def unsuccessful_receipt_validation_stub
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post '/verifyReceipt' do |env|
        [
          200,
          {'Content-Type' => 'application/json'},
          {
            :status => 1,
            :receipt => ActiveSupport::JSON.decode(env[:body])['receipt-data']
          }.to_json
        ]
      end
    end
  end

  def android_receipt(product_ids)
    orders = {:nonce => 7822246098812800204, :orders => []}
    (product_ids).each do |i|
      orders[:orders] << {
        :notificationId => "-915368186294557970",
        :orderId => "971056902421676",
        :packageName =>"xxx.yyy.zzz",
        :productId => i,
        :purchaseTime => 1331562686000,
        :purchaseState => 1,
        :developerPayload => "WEHJSU"
      }
    end
    orders
  end

  # emulate google play sign process
  def sign_android_receipt(receipt)
    private_key = OpenSSL::PKey::RSA.new(Base64.decode64(GOOGLE_PLAY_PRIVATE_KEY))
    signature = private_key.sign(OpenSSL::Digest::SHA1.new, receipt)
    Base64.encode64(signature)
  end
end
