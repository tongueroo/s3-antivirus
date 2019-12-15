require "syslog/logger"

module S3Antivirus
  class Tee
    extend Memoist

    def initialize(path, options={})
      @path, @options = path, options
    end

    def method_missing(name, message, &block)
      if logger.respond_to?(name)
        # Interesting note about level mapping: http://bit.ly/2PP5Y6Z
        #   Messages from Ruby applications are not considered as critical as messages
        #   from other system daemons using syslog(3), so most messages are reduced by one level.
        #
        # Will mimic behavior for puts stdout.
        # Interestingly, the default logger.level is ::Logger::DEBUG which is 0.
        # So can't check against that, so will check against the method name.
        puts message unless name == :debug
        logger.send(name, message, &block)
      else
        super
      end
    end

    def logger
      Syslog::Logger.new(@path)
    end
    memoize :logger
  end
end
