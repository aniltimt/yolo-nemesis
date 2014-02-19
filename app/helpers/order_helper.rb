module OrderHelper
  def tour_pack_url(order)
    S3_TOUR_PACK_BASE_URL + "/%s/%s/%s/%s/%s.pack" % [
      order.tour_country,
      order.tour_city,
      order.tour_id,
      params[:platform_id],
      order.tour_build_id
    ]
  end

  def subtour_pack_url(subtour)
    S3_TOUR_PACK_BASE_URL + "/%s/%s/%s/%s/%s.pack" % [
      subtour.country,
      subtour.city,
      subtour.id,
      params[:platform_id],
      subtour.build_id
    ]
  end

  def tour_xml_url(tour)
    S3_TOUR_PACK_BASE_URL + "/%s/%s/%s/%s/%s.xml" % [
      tour.country,
      tour.city,
      tour.id,
      params[:platform_id],
      tour.build_id
    ]
  end
end
