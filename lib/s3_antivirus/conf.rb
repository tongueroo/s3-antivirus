module S3Antivirus
  module Conf
    extend Memoist

    def conf
      conf = Config.new
      conf.data
    end
    memoize :conf
  end
end
