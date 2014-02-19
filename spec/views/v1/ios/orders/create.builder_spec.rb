require 'spec_helper'

describe 'v1/ios/orders/create.builder' do
  it 'contains data of order and tour' do
    order = FactoryGirl.create(:order)

    assign(:order, order)
    controller.params[:platform_id] = platform_id = 1
    render
    
    result = ActiveSupport::XmlMini.parse(rendered)
    
    ['id', 'tour_id', 'tour_name', 'tour_url', 'tour_build_id'].each do |attribute|
      result['order'][attribute].should == order.send(attribute).to_s
    end
    result['order']['tour_data_url'].should == "https://s3.amazonaws.com/#{AWS_PLACES_BUCKET}/#{order.tour_country}/#{order.tour_city}/#{order.tour_id}/#{platform_id}/#{order.tour_build_id}.pack"
  end
end
