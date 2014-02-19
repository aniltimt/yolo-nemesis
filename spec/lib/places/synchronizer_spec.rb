require 'spec_helper'

describe Places::Synchronizer do
  before do
    @remote_storage = double("Remote storage")
    @local_storage = double("Local storage")
  end

  it 'calls read method on remote storage object' do
    @remote_storage.should_receive(:read)
    @local_storage.stub(:write)

    Places::Synchronizer.new(@remote_storage, @local_storage).run
  end
  
  it 'calls write on local storage object with content if it is not nil' do
    data_content = "Some funny story"
    @remote_storage.stub(:read).and_return(data_content)
    @local_storage.should_receive(:write).with(data_content)
    
    Places::Synchronizer.new(@remote_storage, @local_storage).run
  end
  
  it "doesn't call wite on local storage if content is nil" do
    @remote_storage.stub(:read).and_return(nil)
    @local_storage.should_not_receive(:write)
    
    Places::Synchronizer.new(@remote_storage, @local_storage).run
  end
  
  it 'reponds with true to fresh_data? if update was performed' do
    @remote_storage.stub(:read).and_return("data")
    @local_storage.stub(:write)
    places = Places::Synchronizer.new(@remote_storage, @local_storage)
    places.run
    places.fresh_data?.should be_true
  end
  
  it 'reponds with false to fresh_data? if update was not performed' do
    @remote_storage.stub(:read).and_return(nil)
    @local_storage.stub(:write)
    places = Places::Synchronizer.new(@remote_storage, @local_storage)
    places.run
    places.fresh_data?.should be_false
  end
end