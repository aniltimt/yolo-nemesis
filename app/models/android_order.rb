class AndroidOrder < Order
  attr_accessor :receipt_json, :created_from_preview_user, :signature
end
