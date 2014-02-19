module Places
  module Storage
    class Aws
      
      #include AWS::S3
      
      def initialize(bucket, object_name, etag = nil)
        @bucket, @object_name, @etag = bucket, object_name, etag
        @s3 = AWS::S3.new(
          :access_key_id     => S3_ACCESS_KEY,
          :secret_access_key => S3_SECRET
        )
      end
      
      def read
        options = {}
        options[:if_none_match] = @etag unless @etag.nil?
        value = @s3.buckets[@bucket].objects[@object_name].read(options)
        value.empty? ? nil : value
      rescue AWS::Errors::ServerError => exception
        # we return nil
          nil
      end
    end
  end
end
