module S3Antivirus
  class S3Record
    include Conf

    def initialize(record)
      @record = record # record data from SQS event structure
    end

    def human_key
      text = "s3://#{bucket}/#{key}"
      text += " (version: #{version})" if version
      text
    end

    def bucket
      @record['s3']['bucket']['name']
    end

    def key
      URI.decode(@record['s3']['object']['key']).gsub('+', ' ')
    end

    def version
      @record['s3']['object']['versionId']
    end

    def oversized?
      size > max_size
    end

    def size
      @record['s3']['object']['size']
    end

    def max_size
      conf['volume_size'] * 1073741824 / 2 # in bytes
    end
  end
end
