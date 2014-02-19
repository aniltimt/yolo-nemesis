require 'digest/md5'

module Places
  module Storage
    F = ::File
    class File
      def initialize(path)
        @path = path
      end
      
      def write(data)
        F.open(@path, 'w') do |file|
          file.write(data)
        end
      end
      
      def read
        F.open(@path).read
      end
      
      def etag
        Digest::MD5.hexdigest(read) rescue nil
      end
    end
  end
end
