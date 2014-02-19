class Synchronizer
  def initialize
    cache_dir = Rails.root.join('tmp')
    FileUtils.mkdir_p(cache_dir) unless File.exists?(cache_dir)
    
    @local_storage = Places::Storage::File.new(File.join(cache_dir, 'places.xml'))
    @remote_storage = Places::Storage::Aws.new(AWS_PLACES_BUCKET, 'places.xml', @local_storage.etag)

    @synchronizer = Places::Synchronizer.new(@remote_storage, @local_storage)
  end
  
  def run
    @synchronizer.run
    XmlTourParser.new(@local_storage.read).accept(TourVisitor.new(Tour)) if @synchronizer.fresh_data?
  end
end