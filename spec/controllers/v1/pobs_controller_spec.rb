require 'spec_helper'

describe V1::PobsController do
  before(:each) do
    #AWS::S3.stub(:new, AWS::S3.new(:access_key_id => "TESTKEY", :secret_access_key => "TESTSECRET", :stub_requests => true))
    AWS.stub!
  end

  # since we use truncation strategy for DatabaseCleaner (and after/before_destroy callbacks would not be invoked)
  # we should manually invoke those callbacks and hooks
  after do
    puts '[after] deleting litter'
    PobsBundle.all.each{|pb| pb.destroy}
  end

  it "should create package with pobs" do
    pob_categories = 2.times.map{ FactoryGirl.create(:pob_category) }
    pobs = 5.times.map{ FactoryGirl.create(:pob, :pob_images => 2.times.map{FactoryGirl.create(:pob_image) }, :pob_categories => pob_categories) }
    tour = FactoryGirl.create(:tour)
    Pob.count.should == 5
    PobCategory.count.should == 2

    south = pobs.map(&:latitude).min
    east = pobs.map(&:longitude).max
    north = pobs.map(&:latitude).max
    west = pobs.map(&:longitude).min

    get :create_bundle, {:categories => pob_categories.map(&:id).join(','), :tour_id => tour.id, :se => "#{south},#{east}", :nw => "#{north},#{west}"}
    PobsBundle.count.should == 1 # number of pobs_bundles versions should be 1 at the time
    pob = PobsBundle.last
    [pob.east, pob.south, pob.north, pob.west].should_not include(nil)
    #(PobsBundle.last.east * 10000).truncate.should == (east * 10000).truncate
    #(PobsBundle.last.south * 10000).truncate.should == (south * 10000).truncate
    #(PobsBundle.last.north * 10000).truncate.should == (north * 10000).truncate
    #(PobsBundle.last.west * 10000).truncate.should == (west * 10000).truncate
  end
end
