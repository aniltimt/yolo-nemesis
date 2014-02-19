module Places
  class Synchronizer
    def initialize(remote_storage, local_storage)
      @remote_storage, @local_storage = remote_storage, local_storage
      @fresh_data = false
    end
    
    def run
      data = @remote_storage.read
      if data
        @local_storage.write(data)
        @fresh_data = true
      else
        @fresh_data = false
      end
    end
    
    def fresh_data?
      @fresh_data
    end
  end
end
