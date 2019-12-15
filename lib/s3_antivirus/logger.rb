module S3Antivirus
  module Logger
    def logger
      $logger ||= Tee.new("s3-antivirus")
    end
  end
end
