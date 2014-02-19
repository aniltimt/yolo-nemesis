class IosOrder < Order
  validates :receipt, :valid_receipt => true, :unless => lambda { |order| (order.tour && order.tour.free?) || order.created_from_preview_user}
  
  attr_accessor :receipt_json, :created_from_preview_user
  
  after_validation :set_tour 

  protected
  def set_tour
    return if receipt_json.nil?

    receipt = AppleReceipt.new(receipt_json)
    self.tour_id = Tour.find(receipt.product_id).id
  end
end
