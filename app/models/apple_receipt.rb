class AppleReceipt
  attr_accessor :quantity, :product_id, :transaction_id,
    :purchase_date, :original_transaction_id, :original_purchase_date,
    :app_item_id, :version_external_identifier, :bid, :bvrs

  attr_writer :connection, :base_url

  def initialize(receipt)
    @receipt = receipt
    receipt.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
  
  def connection
    @connection ||= Faraday.new(:url => base_url) do |builder|
      builder.request :json
      builder.use Faraday::Response::ParseJson
    end
  end
  
  def base_url
    @base_url ||= "https://buy.itunes.apple.com"
  end
  
  def product_id=(value)
    @product_id = value.respond_to?(:gsub) ? value.gsub(/com\.digitalfootsteps\.tour\./, '') : value
  end
end
