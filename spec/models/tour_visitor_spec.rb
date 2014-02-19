require 'spec_helper'

# tour_ir comes from TourHelper

describe TourVisitor do
  before do
    @parserStub = Class.new do
      def initialize(parsed_xml)
        @parsed_xml = parsed_xml
      end
      def accept(visitor)
        visitor.visit(@parsed_xml)
      end
    end.new(tour_ir)
  end

  it "saves all tours" do
    modelClass = double('Tour class stub')
    modelClass.stub(:delete_all)
    modelInstance = double('Tour instance mock')
    
    # Mocks and stubs
    [
      {:id => 438, :is_ubertour => "false", :client_id => "1", :name => "History of Kyiv Rus", :url => "/market/tours/438.xml", :build_id => 5, :country => "UA", :city => "Kyiv"},
      {:id => 439, :is_ubertour => "true", :subtours_count => 2, :client_id => "1", :name => "History of Religion", :url => "/market/tours/439.xml", :build_id => 7, :country => "IL", :city => "Jerusalem"},
      {:id => 450, :is_ubertour => "false", :client_id => "1", :name => "History of Religion 2", :url => "/market/tours/450.xml", :build_id => 1, :country => "IL", :city => "Jerusalem"}
    ].each do |hash|
      modelClass.should_receive(:find_or_initialize_by_id).with(hash[:id]).and_return(modelInstance)
      hash.delete(:id)
      modelInstance.should_receive(:update_attributes).with(hash)
    end
    
    @parserStub.accept(TourVisitor.new(modelClass))
  end
end
