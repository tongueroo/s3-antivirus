module S3Antivirus
  class Config
    include Logger

    attr_reader :data
    def initialize(path=nil)
      @data = load(path)
    end

    def load(path)
      YAML.load_file(lookup_path(path))
    end

    def lookup_path(path=nil)
      paths = [
        path,
        "./s3-antivirus.conf",
        "#{ENV['HOME']}/.s3-antivirus.conf",
        "/etc/s3-antivirus.conf"
      ].compact
      found = paths.find { |p| File.exist?(p) }
      unless found
        logger.fatal("FATAL: unable to find the s3-antivirus.conf file. Paths considered: #{paths}")
        exit 1
      end
      found
    end
  end
end
