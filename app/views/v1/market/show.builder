xml.instruct!
tours_opts = {:country => @country, :count => @products.size}
tours_opts.merge!(:city => @city) if @city
xml.tours(tours_opts) do
  @products.each do |product|
    opts = {:name => product.name, :url => market_product_path(product, :format => :xml),
      :mapUrl => map_market_product_path(product, :format => :pack),
      :mediaUrl => media_market_product_path(product, :format => :pack),
			:tourID => product.id
    }
    opts.merge!(:city => product.city) unless @city
    xml.tour(opts)
  end
end
