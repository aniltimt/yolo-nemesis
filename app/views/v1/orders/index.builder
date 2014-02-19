xml.instruct!
xml.orders do
  @orders.each do |order|
    if order.tour.is_ubertour
      xml.order(:id => order.id, :tour_id => order.tour_id, :tour_name => order.tour_name, :tour_url => order.tour_url, :tour_data_url => tour_pack_url(order),:tour_build_id => order.tour_build_id) do |tour|
        order.tour.children.each do |child_tour|
          tour.subtour :id => child_tour.id, :build_id => child_tour.build_id, :tour_data_url => subtour_pack_url(child_tour)
        end
      end
    else
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
end
