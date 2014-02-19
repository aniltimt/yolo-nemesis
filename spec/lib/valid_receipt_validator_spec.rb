require 'spec_helper'

describe ValidReceiptValidator do
  before do
    @model = ar_like_model.new
    @model.receipt = receipt_from_ios
  end
  
  after do
    @stubs.verify_stubbed_calls if @stubs
    ValidReceiptValidator.faraday_adapter = nil
  end

  describe "valid receipt" do
    before do
      @stubs = successful_receipt_validation_stub
      ValidReceiptValidator.faraday_adapter = [:test, @stubs]
    end
    
    it 'passes validation' do
      @model.should be_valid
    end
    
    it 'sets receipt_json' do
      @model.valid?
      @model.receipt_json.should_not be_nil
    end
  end
  
  describe "not valid receipt" do
    before do
      @stubs = unsuccessful_receipt_validation_stub
      ValidReceiptValidator.faraday_adapter = [:test, @stubs]
    end
  
    it 'does not pass validation' do
      @model.should_not be_valid
    end
  end
  
  describe 'configuration' do
    before do
      @verify_url = ValidReceiptValidator.verify_url
      ValidReceiptValidator.verify_url = nil
    end
    
    after do
      ValidReceiptValidator.verify_url = @verify_url
    end
    
    it 'raises exception if verify_url is no set' do
      expect {@model.valid?}.to raise_error(RuntimeError, 'You need to set up verify_url')
    end
  end
  
  # Stubing ActiveRecord-like model
  def ar_like_model
    Class.new do
      extend ActiveModel::Naming
      include ActiveModel::Validations
    
      attr_accessor :receipt, :errors, :receipt_json
    
      validates :receipt, :valid_receipt => true
    
      def initialize
        @errors = ActiveModel::Errors.new(self)
      end
    
      def read_attribute_for_validation(attribute)
        send(attribute)
      end

      def self.human_attribute_name(attribute, options = {})
        attr
      end

      def self.lookup_ancestors
        [self]
      end
    end
  end
end