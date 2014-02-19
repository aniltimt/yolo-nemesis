class AndroidReceipt

  def initialize(receipt, signature)
    @raw_receipt = receipt
    @json_receipt = ActiveSupport::JSON.decode(@raw_receipt)
    @signature = signature
  end

  def valid?    
    key = OpenSSL::PKey::RSA.new(Base64.decode64(GOOGLE_PLAY_PUBLIC_KEY))
    verified = key.verify(OpenSSL::Digest::SHA1.new, Base64.decode64(@signature), @raw_receipt)
    if !verified
      return false
    end
    true
  end

  def product_ids()
    ids = []
    @json_receipt["orders"].each do |order|
      ids << order["productId"].split(".").pop
    end
    ids
  end
end
