module S3Antivirus
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "scan", "Poll SQS queue for s3 virus findings."
    long_desc Help.text(:scan)
    def scan
      Scan.new(options).run
    end

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text(:completion)
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text(:completion_script)
    def completion_script
      Completer::Script.generate
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
