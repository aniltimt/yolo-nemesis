module TourHelper
  def tour_ir
    {"places"=>
      {"count"=>"2",
       "country"=>
        [{"citiesCount"=>"1",
          "toursCount"=>"1",
          "name"=>"UA",
          "city"=>
           {"toursCount"=>"1",
            "name"=>"Kyiv",
            "tour"=>
             {"latestBuild"=>"5",
              "tourID"=>"438",
              "client_id"=>"1",
              "is_ubertour"=>"false",
              "name"=>"History of Kyiv Rus",
              "url"=>"/market/tours/438.xml"}}},
         {"citiesCount"=>"1",
          "toursCount"=>"1",
          "name"=>"IL",
          "city"=>
           {"toursCount"=>"1",
            "name"=>"Jerusalem",
            "tour"=>
             [{"latestBuild"=>"7",
               "tourID"=>"439",
               "client_id"=>"1",
               "is_ubertour"=>"true",
               "subtours_count" => 2,
               "name"=>"History of Religion",
               "url"=>"/market/tours/439.xml"},
              {"latestBuild"=>"1",
               "tourID"=>"450",
               "client_id"=>"1",
               "is_ubertour"=>"false",
               "name"=>"History of Religion 2",
               "url"=>"/market/tours/450.xml"}]}}]}}
  end
end
