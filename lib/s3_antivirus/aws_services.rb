require "aws-sdk-s3"
require "aws-sdk-sns"

module S3Antivirus
  module AwsServices
    extend Memoist

    def s3
      Aws::S3::Client.new
    end
    memoize :s3

    def sns
      Aws::SNS::Client.new
    end
    memoize :sns
  end
end
