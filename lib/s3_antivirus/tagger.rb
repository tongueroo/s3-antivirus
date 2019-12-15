module S3Antivirus
  class Tagger
    include AwsServices
    include Conf

    def initialize(s3_record)
      @s3_record = s3_record
      @bucket, @key, @version = s3_record.bucket, s3_record.key, s3_record.version
      @tag_key = conf['tag_key']
    end

    # Different tag values:
    #
    #   clean
    #   inflected
    #   oversized
    #
    def tag(value)
      params = {
        bucket: @bucket,
        key: @key,
        tagging: {tag_set: [{key: @tag_key, value: value}]}
      }
      params[:version_id] = @version if @version
      s3.put_object_tagging(params)
    end
  end
end
