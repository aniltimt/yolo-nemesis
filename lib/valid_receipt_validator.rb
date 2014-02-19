class ValidReceiptValidator < ActiveModel::EachValidator
  
  class << self
    attr_accessor :faraday_adapter, :verify_url
  end

  def validate_each(record, attribute, value)
    if value.blank?
      record.errors[attribute] << "can't be blank"
      return
    end
      
    response = connection.post(
      '/verifyReceipt',
      {'receipt-data' => value},
      {'Content-Type' => 'application/json'}
    )
    
    unless response.body['status'] == 0
      record.errors[attribute] << "receipt is not valid"
    else
      record.receipt_json = response.body['receipt']
    end
  end
  
  private

  def connection
    raise RuntimeError.new("You need to set up verify_url") if self.class.verify_url.nil?

    ssl_options = {
      :verify   => (File.exists?('/etc/ssl/certs/') && Dir.entries('/etc/ssl/certs/').size > 2),
      :ca_path  => '/etc/ssl/certs/'
    }

    Faraday.new(self.class.verify_url, :ssl => ssl_options) do |builder|
      builder.request :json
      builder.use Faraday::Response::ParseJson
      builder.adapter *(self.class.faraday_adapter ? (self.class.faraday_adapter) : Faraday.default_adapter)
    end
  end
end
