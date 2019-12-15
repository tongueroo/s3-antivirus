module S3Antivirus
  class Notifier
    include AwsServices
    include Conf

    def initialize(s3_record)
      @s3_record = s3_record
      @bucket, @key, @version = s3_record.bucket, s3_record.key, s3_record.version
    end

    def notify(status:, action:)
      data = {
        action: action,
        bucket: @bucket,
        key: @key,
        status: status,
      }
      data[:version] = @version if @version
      message_attributes = data.inject({}) do |result, (k,v)|
        result.merge(
          k => {
            data_type: "String",
            string_value: v
          }
        )
      end
      sns.publish(
        topic_arn: conf['topic'],
        message: "#{@s3_record.human_key} is #{status}, #{action} action executed",
        subject: "s3-antivirus s3://#{@bucket}",
        message_attributes: message_attributes
      )
    end
  end
end
