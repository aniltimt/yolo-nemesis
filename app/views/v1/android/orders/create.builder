xml.instruct!
xml.orders do 
  @orders.each do |order|
    xml.order(
      :id => order.id,
      :tour_id => order.tour_id,
      :tour_name => order.tour_name,
      :tour_url => order.tour_url,
      :tour_data_url => tour_pack_url(order),
      :tour_build_id => order.tour_build_id
    )
  end
end
